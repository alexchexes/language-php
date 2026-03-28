// @ts-check

const path = require("path");
const { spawnSync } = require("child_process");
const { preparePhpGrammarSet } = require("./exportPhpGrammar");

const repoRoot = path.resolve(__dirname, "..");
const defaultGlob = "spec/tmgrammar/**/*.php";

const valueOptions = new Set([
  "-g",
  "--grammar",
  "--config",
  "--xunit-report",
  "--xunit-format",
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

async function main() {
  const args = process.argv.slice(2);
  const grammarPaths = await preparePhpGrammarSet();
  const cliPath = require.resolve("vscode-tmgrammar-test/dist/unit.js");
  const cliArgs = [cliPath];

  for (const grammarPath of grammarPaths) {
    cliArgs.push("-g", grammarPath);
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
