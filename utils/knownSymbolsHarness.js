const fs = require("fs");
const path = require("path");

const UPDATE_SNAPSHOTS =
  process.env.UPDATE_SNAPSHOTS === "1" ||
  process.env.UPDATE_SNAPSHOTS === "true";

const IDENTIFIER_REGEX = /^[A-Za-z_][A-Za-z0-9_]*$/;

const fixturePath = (fileName) =>
  path.join(__dirname, "../spec/fixtures/symbols", fileName);

const readIdentifierList = (fileName) => {
  const filePath = fixturePath(fileName);
  const content = fs.readFileSync(filePath, "utf8");
  const names = [];
  const seen = new Set();

  content.split(/\r?\n/).forEach((raw, index) => {
    const line = raw.trim();
    // .properties format not standardized, different IDE may use #, ! or ; for "toggle comment" action
    if (line.length === 0 || line.startsWith("#") || line.startsWith("!") || line.startsWith(";")) {
      return;
    }

    if (!IDENTIFIER_REGEX.test(line)) {
      throw new Error(
        `Invalid identifier name in ${filePath}:${index + 1}: "${raw}"`,
      );
    }

    if (!seen.has(line)) {
      seen.add(line);
      names.push(line);
    }
  });

  return names.sort((a, b) => a.localeCompare(b));
};

const readSnapshot = (snapshotName) => {
  const snapshotPath = fixturePath(snapshotName);
  if (!fs.existsSync(snapshotPath)) {
    return null;
  }
  return JSON.parse(fs.readFileSync(snapshotPath, "utf8"));
};

const writeSnapshot = (snapshotName, scopes) => {
  const snapshotPath = fixturePath(snapshotName);
  const payload = Object.fromEntries(
    Object.entries(scopes).sort(([a], [b]) => a.localeCompare(b)),
  );

  fs.mkdirSync(path.dirname(snapshotPath), { recursive: true });
  fs.writeFileSync(
    snapshotPath,
    `${JSON.stringify(payload, null, 2)}\n`,
    "utf8",
  );
};

const uniqueInsertionPositions = (segment) => {
  const positions = new Set();
  if (segment.length > 5) {
    positions.add(Math.floor(segment.length / 2));
    positions.add(3);
  }
  if (segment.length > 6) {
    positions.add(4);
  }
  return [...positions].filter(
    (index) => index > 1 && index < segment.length - 1,
  );
};

const generateNearMisses = (identifier) => {
  const candidates = [];
  const seen = new Set();
  const parts = identifier.split("_").filter((item) => item.length > 0);
  const minLength = Math.max(4, Math.floor(identifier.length * 0.6));

  const push = (candidate, { allowShort = false } = {}) => {
    if (!candidate || candidate === identifier || seen.has(candidate)) {
      return;
    }
    if (!IDENTIFIER_REGEX.test(candidate)) {
      return;
    }
    if (!allowShort && candidate.length < minLength) {
      return;
    }
    seen.add(candidate);
    candidates.push(candidate);
  };

  // Baseline variants: append/prepend underscore and remove all underscores.
  push(`${identifier}_`);
  push(`_${identifier}`);
  push(identifier.replace(/_/g, ""));

  // Remove one existing underscore at a time.
  for (let i = 0; i < identifier.length; i += 1) {
    if (identifier[i] === "_") {
      push(identifier.slice(0, i) + identifier.slice(i + 1));
    }
  }

  if (parts.length === 1) {
    // Single-segment identifiers: insert an underscore at representative positions.
    const segment = parts[0];
    if (segment.length > 4) {
      uniqueInsertionPositions(segment).forEach((index) => {
        push(`${segment.slice(0, index)}_${segment.slice(index)}`);
      });
    }
  }

  if (parts.length > 1) {
    // Multi-segment identifiers: optional/missing tail prefixes at each boundary.
    // e.g. xmlrpc_server_call_method -> xmlrpc_server_call_, xmlrpc_server_call, xmlrpc, etc.
    for (let i = 1; i < parts.length; i += 1) {
      const prefix = parts.slice(0, i).join("_");
      push(prefix, { allowShort: true });
      push(`${prefix}_`, { allowShort: true });
    }

    // Missing underscore across the first or last segment boundary.
    push(`${parts[0]}_${parts.slice(1).join("")}`);
    push(`${parts.slice(0, -1).join("")}_${parts[parts.length - 1]}`);

    // Drop one whole segment.
    for (let i = 0; i < parts.length; i += 1) {
      const dropped = parts.filter((_, index) => index !== i);
      if (dropped.length > 0) {
        push(dropped.join("_"));
      }
    }

    // Adjacent segment boundary mistakes: merged pair or doubled separator.
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

    // Extra underscore inserted inside the first or last segment.
    [0, parts.length - 1].forEach((segmentIndex) => {
      const segment = parts[segmentIndex];
      uniqueInsertionPositions(segment).forEach((index) => {
        const clone = [...parts];
        clone[segmentIndex] =
          `${segment.slice(0, index)}_${segment.slice(index)}`;
        push(clone.join("_"));
      });
    });
  }

  return candidates.slice(0, 50);
};

const generateNearMissSet = (identifiers) => {
  const validNames = new Set(identifiers);
  const nearMisses = [];
  const seen = new Set();

  for (const identifier of identifiers) {
    const candidates = generateNearMisses(identifier);

    for (const candidate of candidates) {
      if (validNames.has(candidate) || seen.has(candidate)) {
        continue;
      }

      seen.add(candidate);
      nearMisses.push(candidate);
    }
  }

  return nearMisses;
};

module.exports = {
  UPDATE_SNAPSHOTS,
  readIdentifierList,
  readSnapshot,
  writeSnapshot,
  generateNearMissSet,
};
