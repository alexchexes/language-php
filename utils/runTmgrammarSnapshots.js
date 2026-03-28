// @ts-check

const path = require("path");
const { spawnSync } = require("child_process");
const { preparePhpGrammarSet } = require("./exportPhpGrammar");

const repoRoot = path.resolve(__dirname, "..");
const defaultGlob = "spec/tmgrammar-snap/**/*.php";

const valueOptions = new Set([
  "-g",
  "--grammar",
  "--config",
  "-s",
  "--scope",
]);

/**
 * @param {string[]} args
 * @returns {boolean}
 */
function hasExplicitTestcaseArg(args) {
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];

    if (!arg.startsWith("-")) {
      return true;
    }

    const optionName = arg.split("=")[0];
    if (valueOptions.has(optionName) && !arg.includes("=")) {
      index++;
    }
  }

  return false;
}

/**
 * @param {string[]} args
 * @returns {boolean}
 */
function hasExplicitScopeArg(args) {
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];

    if (arg === "-s" || arg === "--scope" || arg.startsWith("-s=") || arg.startsWith("--scope=")) {
      return true;
    }

    const optionName = arg.split("=")[0];
    if (valueOptions.has(optionName) && !arg.includes("=")) {
      index++;
    }
  }

  return false;
}

async function main() {
  const args = process.argv.slice(2);
  const grammarPaths = await preparePhpGrammarSet();
  const cliPath = require.resolve("vscode-tmgrammar-test/dist/snapshot.js");
  const cliArgs = [cliPath];

  for (const grammarPath of grammarPaths) {
    cliArgs.push("-g", grammarPath);
  }

  if (!hasExplicitScopeArg(args)) {
    cliArgs.push("-s", "source.php");
  }

  cliArgs.push(...args);

  if (!hasExplicitTestcaseArg(args)) {
    cliArgs.push(defaultGlob);
  }

  const result = spawnSync(process.execPath, cliArgs, {
    cwd: repoRoot,
    stdio: "inherit",
  });

  if (result.error) {
    throw result.error;
  }

  process.exit(result.status === null ? 1 : result.status);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
