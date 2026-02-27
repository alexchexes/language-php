import { resolveOptions } from "./config/resolve-options.mjs";
import { buildStructureFromCompTrie } from "./ir/build-structure.mjs";
import { applyPrefixGroupingTransform } from "./ir/transforms/prefix-grouping.mjs";
import { applyOptionalEmptyAltTransform } from "./ir/transforms/optional-empty-alt.mjs";
import { parseInputLines, uniqueStable } from "./input.mjs";
import { renderBalanced } from "./render/balanced.mjs";
import { renderCompact } from "./render/compact.mjs";
import { renderPretty } from "./render/pretty.mjs";
import { buildTrie, compressTrie } from "./trie.mjs";

/**
 * Build regex from compressed trie via structure + transform + render pipeline.
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} compTrie
 * @param {{
 *   pretty?: boolean,
 *   format?: "pretty" | "compact" | "balanced",
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing",
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
 * }} opts
 * @returns {string}
 */
export function buildRegexFromCompTrie(compTrie, opts = {}) {
  const resolved = resolveOptions(opts);
  let ir = buildStructureFromCompTrie(compTrie, {
    minWordSplitLen: resolved.minWordSplitLen,
    forbidSplitWords: resolved.forbidSplitWords,
    forceSplitWords: resolved.forceSplitWords,
  });

  ir = applyOptionalEmptyAltTransform(ir);
  ir = applyPrefixGroupingTransform(ir, {
    minWordSplitLen: resolved.minWordSplitLen,
    forbidSplitWords: resolved.forbidSplitWords,
    forceSplitWords: resolved.forceSplitWords,
  });
  ir = applyOptionalEmptyAltTransform(ir);

  if (resolved.format === "compact") {
    return renderCompact(ir, {
      indent: resolved.indent,
      wrap: resolved.wrap,
      groupStyle: resolved.groupStyle,
    });
  }

  if (resolved.format === "balanced") {
    return renderBalanced(ir, {
      indent: resolved.indent,
      wrap: resolved.wrap,
      groupStyle: resolved.groupStyle,
    });
  }

  return renderPretty(ir, {
    indent: resolved.indent,
    wrap: resolved.wrap,
    groupStyle: resolved.groupStyle,
  });
}

/**
 * Build regex from literal strings via trie grouping pipeline.
 * @param {string[]} strings
 * @param {{
 *   pretty?: boolean,
 *   format?: "pretty" | "compact" | "balanced",
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing",
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
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
