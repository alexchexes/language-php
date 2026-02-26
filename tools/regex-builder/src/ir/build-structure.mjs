import {
  advanceSplitContext,
  createInitialSplitContext,
} from "../policy/split-context.mjs";
import {
  canFactorAfterPrefix,
  directAltCount,
} from "../policy/split-policy.mjs";
import { altGroupNode, concatNode, literalNode } from "./node-utils.mjs";

/**
 * Build formatting-agnostic IR from compressed trie.
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} node
 * @param {{ minWordSplitLen?: number, forbidSplitWords?: Set<string> }} opts
 * @returns {import("./types.mjs").RegexIR}
 */
export function buildStructureFromCompTrie(node, opts = {}) {
  return buildNode(node, opts, createInitialSplitContext());
}

/**
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} node
 * @param {{ minWordSplitLen?: number, forbidSplitWords?: Set<string> }} opts
 * @param {{ wordTail: string, lastChar: string | null, localPrefixLen: number }} state
 * @returns {import("./types.mjs").RegexIR}
 */
function buildNode(node, opts, state) {
  const alts = buildNodeAlternatives(node, opts, state);
  if (alts.length === 0) return literalNode("");
  if (alts.length === 1) return alts[0];
  return altGroupNode(alts, { force: true });
}

/**
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} node
 * @param {{ minWordSplitLen?: number, forbidSplitWords?: Set<string> }} opts
 * @param {{ wordTail: string, lastChar: string | null, localPrefixLen: number }} state
 * @returns {import("./types.mjs").RegexIR[]}
 */
function buildNodeAlternatives(node, opts, state) {
  /** @type {import("./types.mjs").RegexIR[]} */
  const alts = [];

  if (node.terminal) {
    alts.push(literalNode(""));
  }

  for (const edge of node.edges) {
    const nextState = advanceSplitContext(state, edge.label);
    const edgeLiteral = literalNode(edge.label);
    const childAltCount = directAltCount(edge.node);

    if (childAltCount <= 1) {
      const childExpr = buildNode(edge.node, opts, nextState);
      alts.push(concatNode([edgeLiteral, childExpr]));
      continue;
    }

    if (canFactorAfterPrefix(edge.node, nextState, opts)) {
      const factorState = { ...nextState, localPrefixLen: 0 };
      const childExpr = buildNode(edge.node, opts, factorState);
      alts.push(concatNode([edgeLiteral, childExpr]));
      continue;
    }

    const childAlts = buildNodeAlternatives(edge.node, opts, nextState);
    for (const childAlt of childAlts) {
      alts.push(concatNode([edgeLiteral, childAlt]));
    }
  }

  return alts;
}
