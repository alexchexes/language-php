// @ts-check

const fs = require("fs");
const path = require("path");
const { ensureGrammarFile, parseRawGrammar } = require("./loadGrammar");

const repoRoot = path.resolve(__dirname, "..");
const exportedDir = path.join(repoRoot, "tmp", "tmgrammar");

// Stub unsupported embedded scopes so source.php stays loadable in this
// tmgrammar harness.
const stubScopeNames = [
  "text.html.php.blade",
  "source.smarty",
  "source.python",
  "source.coffee",
  "source.graphql",
  "source.java",
  "source.jsdoc",
  "source.js.regexp",
];

/**
 * @param {string} sourcePath
 * @param {string} destinationPath
 * @returns {string}
 */
function exportGrammarFile(sourcePath, destinationPath) {
  const source = fs.readFileSync(sourcePath);
  const grammar = parseRawGrammar(source, sourcePath);
  fs.mkdirSync(path.dirname(destinationPath), { recursive: true });
  fs.writeFileSync(destinationPath, `${JSON.stringify(grammar, null, 2)}\n`);
  return destinationPath;
}

/**
 * @param {string} scopeName
 * @returns {string}
 */
function writeStubGrammar(scopeName) {
  const destinationPath = path.join(
    exportedDir,
    `stub-${scopeName.replace(/[^\w.-]+/g, "_")}.tmLanguage.json`
  );
  const grammar = {
    scopeName,
    patterns: [],
    repository: {},
  };
  fs.mkdirSync(path.dirname(destinationPath), { recursive: true });
  fs.writeFileSync(destinationPath, `${JSON.stringify(grammar, null, 2)}\n`);
  return destinationPath;
}

/**
 * @param {string} scopeName
 * @returns {Promise<string>}
 */
async function ensureAvailableGrammar(scopeName) {
  const grammarPath = await ensureGrammarFile(scopeName);
  if (typeof grammarPath === "string") {
    return grammarPath;
  }
  throw new Error(`Imported grammar is not available for ${scopeName}`);
}

/**
 * @returns {Promise<string[]>}
 */
async function preparePhpGrammarSet() {
  const phpGrammarPath = await ensureAvailableGrammar("source.php");
  const [
    htmlBasicPath,
    xmlPath,
    sqlPath,
    jsPath,
    jsonPath,
    cssPath,
  ] = await Promise.all([
    ensureAvailableGrammar("text.html.basic"),
    ensureAvailableGrammar("text.xml"),
    ensureAvailableGrammar("source.sql"),
    ensureAvailableGrammar("source.js"),
    ensureAvailableGrammar("source.json"),
    ensureAvailableGrammar("source.css"),
  ]);

  return [
    exportGrammarFile(
      phpGrammarPath,
      path.join(exportedDir, "php.tmLanguage.json")
    ),
    exportGrammarFile(
      htmlBasicPath,
      path.join(exportedDir, "text.html.basic.tmLanguage.json")
    ),
    xmlPath,
    sqlPath,
    exportGrammarFile(
      jsPath,
      path.join(exportedDir, "source.js.tmLanguage.json")
    ),
    jsonPath,
    cssPath,
    ...stubScopeNames.map((scopeName) => writeStubGrammar(scopeName)),
  ];
}

module.exports = {
  ensureAvailableGrammar,
  exportGrammarFile,
  preparePhpGrammarSet,
  writeStubGrammar,
};

if (require.main === module) {
  preparePhpGrammarSet().then((paths) => {
    process.stdout.write(`${paths.join("\n")}\n`);
  });
}
