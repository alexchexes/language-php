import fs from "node:fs/promises";
import { parseInputLines, uniqueStable } from "../input.mjs";
import { buildRegexFromCompTrie } from "../index.mjs";
import { buildTrie, compTrieToObject, compressTrie } from "../trie.mjs";
import { parseArgs, printHelpAndExit } from "./parse-args.mjs";

/**
 * @param {string[]} [argv]
 */
export async function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  if (!args.file) printHelpAndExit(1);

  const text = await fs.readFile(args.file, "utf8");
  const strings = parseInputLines(text);
  if (strings.length === 0) {
    throw new Error("No input strings found.");
  }

  const trie = buildTrie(uniqueStable(strings));
  const comp = compressTrie(trie);

  if (args.json) {
    console.log(JSON.stringify(compTrieToObject(comp), null, 2));
    return;
  }

  const rendered = buildRegexFromCompTrie(comp, args);
  console.log(rendered);
}
