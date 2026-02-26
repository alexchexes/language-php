import {
  advanceSplitContext,
  createInitialSplitContext,
} from "../policy/split-context.mjs";
import {
  directAltCount,
} from "../policy/split-policy.mjs";
import {
  evaluateTrieSplitForDef,
  listDirectAltDefs,
} from "../policy/split-engine.mjs";
import { altGroupNode, concatNode, literalNode } from "./node-utils.mjs";

/**
 * Build formatting-agnostic IR from compressed trie.
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} node
 * @param {{ minWordSplitLen: number, forbidSplitWords: Set<string>, forceSplitWords: Set<string> }} opts
 * @returns {import("./types.mjs").RegexIR}
 */
export function buildStructureFromCompTrie(node, opts) {
  return buildNode(node, opts, createInitialSplitContext());
}

/**
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} node
 * @param {{ minWordSplitLen: number, forbidSplitWords: Set<string>, forceSplitWords: Set<string> }} opts
 * @param {{ fullTail: string, wordTail: string, lastChar: string | null, localPrefixLen: number }} state
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
 * @param {{ minWordSplitLen: number, forbidSplitWords: Set<string>, forceSplitWords: Set<string> }} opts
 * @param {{ fullTail: string, wordTail: string, lastChar: string | null, localPrefixLen: number }} state
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

    const directDefs = listDirectAltDefs(edge.node);
    const chunks = buildDirectAltChunksByPredicate(
      directDefs,
      (def) => evaluateTrieSplitForDef(nextState, def, opts).allowed,
    );

    for (const chunk of chunks) {
      const chunkNode = nodeFromDirectAltDefs(chunk.defs);

      if (chunk.factorable) {
        const factorState = { ...nextState, localPrefixLen: 0 };
        const childExpr = buildNode(chunkNode, opts, factorState);
        alts.push(concatNode([edgeLiteral, childExpr]));
      } else {
        const childAlts = buildNodeAlternatives(chunkNode, opts, nextState);
        for (const childAlt of childAlts) {
          alts.push(concatNode([edgeLiteral, childAlt]));
        }
      }
    }
  }

  return alts;
}

/**
 * @param {Array<{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }>} defs
 * @returns {{ terminal: boolean, edges: Array<{ label: string, node: any }> }}
 */
function nodeFromDirectAltDefs(defs) {
  return {
    terminal: defs.some((def) => def.kind === "terminal"),
    edges: defs.filter((def) => def.kind === "edge").map((def) => def.edge),
  };
}

/**
 * @param {Array<{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }>} defs
 * @param {(def: { kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }) => boolean} predicate
 * @returns {Array<{ factorable: boolean, defs: Array<{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }> }>}
 */
function buildDirectAltChunksByPredicate(defs, predicate) {
  /** @type {Array<{ factorable: boolean, defs: Array<{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }> }>} */
  const chunks = [];

  for (const def of defs) {
    const factorable = predicate(def);
    const prev = chunks[chunks.length - 1];

    if (prev && prev.factorable === factorable) {
      prev.defs.push(def);
    } else {
      chunks.push({ factorable, defs: [def] });
    }
  }

  return chunks;
}
