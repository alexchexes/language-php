import { buildStructureFromCompTrie } from "./ir/build-structure.mjs";
import { applyPrefixGroupingTransform } from "./ir/transforms/prefix-grouping.mjs";
import { applyOptionalEmptyAltTransform } from "./ir/transforms/optional-empty-alt.mjs";
import { parseInputLines, uniqueStable } from "./input.mjs";
import { renderCompact } from "./render/compact.mjs";
import { renderPretty } from "./render/pretty.mjs";
import { buildTrie, compressTrie } from "./trie.mjs";

/**
 * Build regex from compressed trie via structure + transform + render pipeline.
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} compTrie
 * @param {{
 *   pretty?: boolean,
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing",
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   enableSuffixGrouping?: boolean
 * }} opts
 * @returns {string}
 */
export function buildRegexFromCompTrie(compTrie, opts = {}) {
  let ir = buildStructureFromCompTrie(compTrie, {
    minWordSplitLen: opts.minWordSplitLen,
    forbidSplitWords: opts.forbidSplitWords,
  });

  ir = applyOptionalEmptyAltTransform(ir);
  ir = applyPrefixGroupingTransform(ir, {
    minWordSplitLen: opts.minWordSplitLen,
    forbidSplitWords: opts.forbidSplitWords,
    enableSuffixGrouping: opts.enableSuffixGrouping,
  });
  ir = applyOptionalEmptyAltTransform(ir);

  if (opts.pretty === false) {
    return renderCompact(ir, { groupStyle: opts.groupStyle });
  }

  return renderPretty(ir, {
    indent: opts.indent,
    wrap: opts.wrap,
    groupStyle: opts.groupStyle,
  });
}

/**
 * Build regex from literal strings via trie grouping pipeline.
 * @param {string[]} strings
 * @param {{
 *   pretty?: boolean,
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing",
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   enableSuffixGrouping?: boolean
 * }} opts
 * @returns {string}
 */
export function buildRegexFromStrings(strings, opts = {}) {
  const uniq = uniqueStable(strings);
  const trie = buildTrie(uniq);
  const comp = compressTrie(trie);
  return buildRegexFromCompTrie(comp, opts);
}

export { parseInputLines, uniqueStable };
