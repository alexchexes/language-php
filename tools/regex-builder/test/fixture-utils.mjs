import fs from "node:fs/promises";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const TEST_DIR = __dirname;
export const TOOL_DIR = path.resolve(TEST_DIR, "..");
export const REPO_DIR = path.resolve(TOOL_DIR, "..", "..");
export const CLI_PATH = path.join(TOOL_DIR, "regex-builder.mjs");
export const FIXTURES_DIR = path.join(TEST_DIR, "fixtures");
export const UPDATE_HINT = "Run `npm run -s test:regex-builder:update` to create/update expected outputs.";

export function normalizeLineEndings(text) {
  return String(text).replace(/\r\n?/g, "\n");
}

export function ensureTrailingNewline(text) {
  return text.endsWith("\n") ? text : `${text}\n`;
}

export function parseArgLines(raw) {
  return normalizeLineEndings(raw)
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"));
}

export function parseWordLines(raw) {
  return normalizeLineEndings(raw)
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"));
}

export function parseInputLinesLikeTool(raw) {
  return normalizeLineEndings(raw)
    .split("\n")
    .map((line) => line.trim())
    .map((line) => line.replace(/^\|+\s*/, ""))
    .filter(Boolean);
}

export async function pathExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch (err) {
    if (err && err.code === "ENOENT") return false;
    throw err;
  }
}

async function readTextIfExists(filePath) {
  if (!(await pathExists(filePath))) return null;
  return fs.readFile(filePath, "utf8");
}

function quoteArg(arg) {
  if (!/[ \t"]/u.test(arg)) return arg;
  return `"${arg.replace(/"/g, '\\"')}"`;
}

export function formatCliCommand(inputPath, args, compact = false) {
  const argv = [process.execPath, CLI_PATH, inputPath, ...args];
  if (compact) argv.push("--compact");
  return argv.map(quoteArg).join(" ");
}

export function formatSpawnFailure(label, result, command) {
  const parts = [
    `${label} failed.`,
    `Command: ${command}`,
    `Exit code: ${String(result.status)}`,
  ];

  if (result.error) {
    parts.push(`Error: ${result.error.message}`);
  }
  if (result.stdout) {
    parts.push(`stdout:\n${result.stdout}`);
  }
  if (result.stderr) {
    parts.push(`stderr:\n${result.stderr}`);
  }

  return parts.join("\n");
}

export function runRegexBuilder({ inputPath, args, compact = false, env = {} }) {
  const argv = [CLI_PATH, inputPath, ...args];
  if (compact) argv.push("--compact");

  return spawnSync(process.execPath, argv, {
    cwd: REPO_DIR,
    encoding: "utf8",
    env: {
      ...process.env,
      ...env,
    },
    windowsHide: true,
  });
}

export async function listFixtureDirs(baseDir = FIXTURES_DIR) {
  if (!(await pathExists(baseDir))) return [];

  const entries = await fs.readdir(baseDir, { withFileTypes: true });

  return entries
    .filter((entry) => entry.isDirectory())
    .map((entry) => path.join(baseDir, entry.name))
    .sort((a, b) => path.basename(a).localeCompare(path.basename(b)));
}

function requiredFileError(fixtureId, filePath) {
  return `[${fixtureId}] Missing required file: ${filePath}`;
}

export async function loadFixture(
  fixtureDir,
  { requireExpected = true } = {},
) {
  const id = path.basename(fixtureDir);
  const inputPath = path.join(fixtureDir, "input.txt");
  const argsPath = path.join(fixtureDir, "args.txt");
  const positivePath = path.join(fixtureDir, "positive.txt");
  const negativePath = path.join(fixtureDir, "negative.txt");
  const expectedPrettyPath = path.join(fixtureDir, "expected.re");
  const expectedCompactPath = path.join(fixtureDir, "expected-compact.re");

  if (!(await pathExists(inputPath))) {
    throw new Error(requiredFileError(id, inputPath));
  }
  if (!(await pathExists(negativePath))) {
    throw new Error(requiredFileError(id, negativePath));
  }

  if (requireExpected) {
    if (!(await pathExists(expectedPrettyPath))) {
      throw new Error(
        `[${id}] Missing expected file: ${expectedPrettyPath}. ${UPDATE_HINT}`,
      );
    }
    if (!(await pathExists(expectedCompactPath))) {
      throw new Error(
        `[${id}] Missing expected file: ${expectedCompactPath}. ${UPDATE_HINT}`,
      );
    }
  }

  const inputRaw = await fs.readFile(inputPath, "utf8");
  const argsRaw = await readTextIfExists(argsPath);
  const positiveRaw = await readTextIfExists(positivePath);
  const negativeRaw = await fs.readFile(negativePath, "utf8");

  const args = argsRaw == null ? [] : parseArgLines(argsRaw);
  const positives =
    positiveRaw == null
      ? parseInputLinesLikeTool(inputRaw)
      : parseWordLines(positiveRaw);
  const negatives = parseWordLines(negativeRaw);

  if (positives.length === 0) {
    throw new Error(`[${id}] Positive sample set is empty.`);
  }
  if (negatives.length === 0) {
    throw new Error(`[${id}] Negative sample set is empty.`);
  }

  return {
    id,
    fixtureDir,
    inputPath,
    args,
    positives,
    negatives,
    expectedPrettyPath,
    expectedCompactPath,
  };
}
