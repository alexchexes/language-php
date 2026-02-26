import { IR_NODE_KINDS } from "../types.mjs";
import { altGroupNode, concatNode, optionalNode } from "../node-utils.mjs";
import { applyAffixGroupingPlanner } from "./grouping/candidate-planner.mjs";
import { regroupByForcedNestedPrefix } from "./grouping/forced-nested.mjs";

/**
 * Structural regrouping pass for prefix/suffix factoring.
 *
 * @param {import("../types.mjs").RegexIR} node
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR}
 */
export function applyPrefixGroupingTransform(node, opts) {
  return visit(node, opts);
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR}
 */
function visit(node, opts) {
  switch (node.kind) {
    case IR_NODE_KINDS.literal:
      return node;

    case IR_NODE_KINDS.concat:
      return concatNode(node.parts.map((part) => visit(part, opts)));

    case IR_NODE_KINDS.optional:
      return optionalNode(visit(node.child, opts));

    case IR_NODE_KINDS.altGroup: {
      const visitedAlts = node.alternatives.map((alt) => visit(alt, opts));
      const grouped = applyAffixGroupingPlanner(visitedAlts, opts);
      const withForcedNested = regroupByForcedNestedPrefix(grouped, opts);
      return altGroupNode(withForcedNested, { force: true });
    }

    default:
      return node;
  }
}

