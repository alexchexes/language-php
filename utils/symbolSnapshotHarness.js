const fs = require("fs");
const path = require("path");

const paths = {
  constantsList: path.join(__dirname, "../spec/fixtures/symbols/constants.txt"),
  functionsList: path.join(__dirname, "../spec/fixtures/symbols/functions.txt"),
  constantsSnapshot: path.join(
    __dirname,
    "../spec/fixtures/symbols/constants.scopes.snapshot.json"
  ),
  functionsSnapshot: path.join(
    __dirname,
    "../spec/fixtures/symbols/functions.scopes.snapshot.json"
  ),
};

const UPDATE_SNAPSHOTS =
  process.env.UPDATE_SNAPSHOTS === "1" ||
  process.env.UPDATE_SNAPSHOTS === "true";
const NEAR_MISS_MAX_PER_IDENTIFIER = 50;
const NEAR_MISS_MAX_TOTAL = 500_000;

const IDENTIFIER_REGEX = /^[A-Za-z_][A-Za-z0-9_]*$/;

const readIdentifierList = (filePath) => {
  const content = fs.readFileSync(filePath, "utf8");
  const names = [];
  const seen = new Set();

  content.split(/\r?\n/).forEach((raw, index) => {
    const line = raw.trim();
    if (line.length === 0 || line.startsWith("#")) return;
    if (!IDENTIFIER_REGEX.test(line)) {
      throw new Error(
        `Invalid identifier in ${filePath}:${index + 1}: "${raw}"`
      );
    }

    if (!seen.has(line)) {
      seen.add(line);
      names.push(line);
    }
  });

  return names.sort((a, b) => a.localeCompare(b));
};

const getTerminalScope = (tokens, value) => {
  const token = tokens.find((item) => item.value === value);
  if (!token || !Array.isArray(token.scopes) || token.scopes.length === 0) {
    return null;
  }
  return token.scopes[token.scopes.length - 1];
};

const scopeForConstant = (grammar, name) => {
  const { tokens } = grammar.tokenizeLine(`${name};`);
  return getTerminalScope(tokens, name);
};

const scopeForFunction = (grammar, name) => {
  const { tokens } = grammar.tokenizeLine(`${name}($a);`);
  return getTerminalScope(tokens, name);
};

const captureScopes = (grammar, names, symbolType) => {
  const scopes = {};
  const scopeFn = symbolType === "constant" ? scopeForConstant : scopeForFunction;
  names.forEach((name) => {
    scopes[name] = scopeFn(grammar, name);
  });
  return scopes;
};

const sortedEntriesObject = (obj) =>
  Object.fromEntries(Object.entries(obj).sort(([a], [b]) => a.localeCompare(b)));

const readSnapshot = (snapshotPath) => {
  if (!fs.existsSync(snapshotPath)) return null;
  return JSON.parse(fs.readFileSync(snapshotPath, "utf8"));
};

const writeSnapshot = (snapshotPath, scopes) => {
  const payload = sortedEntriesObject(scopes);

  fs.mkdirSync(path.dirname(snapshotPath), { recursive: true });
  fs.writeFileSync(snapshotPath, `${JSON.stringify(payload, null, 2)}\n`, "utf8");
};

const diffSnapshots = (expectedEntries, actualEntries) => {
  const expectedKeys = new Set(Object.keys(expectedEntries));
  const actualKeys = new Set(Object.keys(actualEntries));

  const missing = [];
  const unexpected = [];
  const changed = [];

  expectedKeys.forEach((key) => {
    if (!actualKeys.has(key)) {
      missing.push(key);
      return;
    }
    if (expectedEntries[key] !== actualEntries[key]) {
      changed.push({
        name: key,
        expected: expectedEntries[key],
        actual: actualEntries[key],
      });
    }
  });

  actualKeys.forEach((key) => {
    if (!expectedKeys.has(key)) unexpected.push(key);
  });

  return { missing, unexpected, changed };
};

const uniqueInsertionPositions = (segment) => {
  const positions = new Set();
  if (segment.length > 5) positions.add(Math.floor(segment.length / 2));
  if (segment.length > 6) positions.add(4);
  if (segment.length > 5) positions.add(3);
  return [...positions].filter((index) => index > 1 && index < segment.length - 1);
};

const generateNearMisses = (identifier) => {
  const candidates = [];
  const seen = new Set();
  const parts = identifier.split("_").filter((item) => item.length > 0);
  const minLength = Math.max(4, Math.floor(identifier.length * 0.6));

  const push = (candidate, { allowShort = false } = {}) => {
    if (!candidate || candidate === identifier || seen.has(candidate)) return;
    if (!IDENTIFIER_REGEX.test(candidate)) return;
    if (!allowShort && candidate.length < minLength) return;
    seen.add(candidate);
    candidates.push(candidate);
  };

  push(`${identifier}_`);
  push(`_${identifier}`);
  push(identifier.replace(/_/g, ""));

  for (let i = 0; i < identifier.length; i += 1) {
    if (identifier[i] === "_") {
      push(identifier.slice(0, i) + identifier.slice(i + 1));
    }
  }

  if (parts.length === 1) {
    const segment = parts[0];
    if (segment.length > 4) {
      uniqueInsertionPositions(segment).forEach((index) => {
        push(`${segment.slice(0, index)}_${segment.slice(index)}`);
      });
    }
  }

  if (parts.length > 1) {
    // Catch optional-tail / missing-tail mistakes at every boundary:
    // e.g. xmlrpc_server_call_method -> xmlrpc_server_call_, xmlrpc_server_call, xmlrpc, etc.
    for (let i = 1; i < parts.length; i += 1) {
      const prefix = parts.slice(0, i).join("_");
      push(prefix, { allowShort: true });
      push(`${prefix}_`, { allowShort: true });
    }

    push(`${parts[0]}_${parts.slice(1).join("")}`);
    push(`${parts.slice(0, -1).join("")}_${parts[parts.length - 1]}`);

    for (let i = 0; i < parts.length; i += 1) {
      const dropped = parts.filter((_, index) => index !== i);
      if (dropped.length > 0) push(dropped.join("_"));
    }

    for (let i = 0; i < parts.length - 1; i += 1) {
      const merged = [
        ...parts.slice(0, i),
        `${parts[i]}${parts[i + 1]}`,
        ...parts.slice(i + 2),
      ];
      push(merged.join("_"));

      const left = parts.slice(0, i + 1).join("_");
      const right = parts.slice(i + 1).join("_");
      push(`${left}__${right}`);
    }

    [0, parts.length - 1].forEach((segmentIndex) => {
      const segment = parts[segmentIndex];
      uniqueInsertionPositions(segment).forEach((index) => {
        const clone = [...parts];
        clone[segmentIndex] = `${segment.slice(0, index)}_${segment.slice(index)}`;
        push(clone.join("_"));
      });
    });
  }

  return candidates.slice(0, NEAR_MISS_MAX_PER_IDENTIFIER);
};

const buildNearMissSet = (identifiers) => {
  const validNames = new Set(identifiers);
  const nearMisses = [];
  const seen = new Set();

  for (const identifier of identifiers) {
    const candidates = generateNearMisses(identifier);
    for (const candidate of candidates) {
      if (validNames.has(candidate) || seen.has(candidate)) continue;
      seen.add(candidate);
      nearMisses.push(candidate);
      if (nearMisses.length >= NEAR_MISS_MAX_TOTAL) return nearMisses;
    }
  }

  return nearMisses;
};

module.exports = {
  paths,
  UPDATE_SNAPSHOTS,
  readIdentifierList,
  scopeForConstant,
  scopeForFunction,
  captureScopes,
  readSnapshot,
  writeSnapshot,
  diffSnapshots,
  buildNearMissSet,
};
