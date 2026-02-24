import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import vm from "node:vm";
import { fileURLToPath } from "node:url";
import { compile } from "coffeescript";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const repoRoot = path.resolve(__dirname, "../../..");
const extensionRoot = path.resolve(__dirname, "..");
const syntaxesDir = path.join(extensionRoot, "syntaxes");

const grammarTargets = [
  {
    source: path.join(repoRoot, "grammars", "php.cson"),
    output: path.join(syntaxesDir, "php.tmLanguage.json"),
  },
  {
    source: path.join(repoRoot, "grammars", "html.cson"),
    output: path.join(syntaxesDir, "html.tmLanguage.json"),
  },
];

function parseCsonToObject(csonText, sourcePath) {
  const compiled = compile(csonText, {
    bare: true,
    header: false,
    sourceMap: false,
  });

  const grammar = vm.runInNewContext(compiled, {}, { filename: sourcePath });
  if (!grammar || typeof grammar !== "object" || Array.isArray(grammar)) {
    throw new Error(`Expected grammar object from ${sourcePath}`);
  }
  return grammar;
}

async function main() {
  await mkdir(syntaxesDir, { recursive: true });

  for (const target of grammarTargets) {
    const sourceText = await readFile(target.source, "utf8");
    const grammar = parseCsonToObject(sourceText, target.source);
    await writeFile(target.output, `${JSON.stringify(grammar, null, 2)}\n`, "utf8");
    console.log(`Wrote ${path.relative(repoRoot, target.output)}`);
  }
}

main().catch((error) => {
  console.error(error.message || error);
  process.exitCode = 1;
});

