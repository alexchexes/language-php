import fs from "node:fs/promises";
import { parseInputLines, uniqueStable } from "../input.mjs";
import { buildRegexFromCompTrie } from "../index.mjs";
import { buildTrie, compTrieToObject, compressTrie } from "../trie.mjs";
import { parseArgs, printHelpAndExit } from "./parse-args.mjs";

/**
 * @param {string[]} [argv]
 */
export async function main(argv = process.argv.slice(2)) {
  const parsed = parseArgs(argv);
  if (!parsed.file) printHelpAndExit(1);

  const text = await fs.readFile(parsed.file, "utf8");
  const strings = parseInputLines(text);
  if (strings.length === 0) {
    throw new Error("No input strings found.");
  }

  const trie = buildTrie(uniqueStable(strings));
  const comp = compressTrie(trie);

  if (parsed.json === true) {
    console.log(JSON.stringify(compTrieToObject(comp), null, 2));
    return;
  }

  const rendered = buildRegexFromCompTrie(comp, parsed);
  console.log(rendered);
}
