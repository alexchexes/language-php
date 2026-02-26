import path from "node:path";
import { fileURLToPath } from "node:url";
import { main } from "./src/cli/main.mjs";

export { buildRegexFromCompTrie, buildRegexFromStrings } from "./src/index.mjs";
export { buildTrie, compTrieToObject, compressTrie } from "./src/trie.mjs";

const isMain =
  path.resolve(process.argv[1] || "") === fileURLToPath(import.meta.url);

if (isMain) {
  main().catch((err) => {
    console.error(err?.stack || String(err));
    process.exit(1);
  });
}
