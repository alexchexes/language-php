import { evaluateTrieSplit } from "./split-engine.mjs";

/**
 * Direct alt-count of a compressed trie node before rendering.
 * @param {{ terminal: boolean, edges: Array<any> }} node
 * @returns {number}
 */
export function directAltCount(node) {
  return (node.terminal ? 1 : 0) + node.edges.length;
}

/**
 * @param {{ fullTail: string }} afterPrefixState
 * @param {{ forceSplitWords: Set<string> }} opts
 * @returns {boolean}
 */
export function isForceSplitPoint(afterPrefixState, opts) {
  return opts.forceSplitWords.has(afterPrefixState.fullTail);
}

/**
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} childNode
 * @param {{ fullTail: string, wordTail: string, lastChar: string | null, localPrefixLen: number }} afterPrefixState
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {boolean}
 */
export function canFactorAfterPrefix(childNode, afterPrefixState, opts) {
  return evaluateTrieSplit(afterPrefixState, childNode, opts).allowed;
}

