import { IR_NODE_KINDS } from "../types.mjs";
import {
  altGroupNode,
  concatNode,
  isEmptyLiteral,
  optionalNode,
} from "../node-utils.mjs";

/**
 * Normalize optional-empty alternation:
 *   (|A|B|C) => (A|B|C)?
 * @param {import("../types.mjs").RegexIR} node
 * @returns {import("../types.mjs").RegexIR}
 */
export function applyOptionalEmptyAltTransform(node) {
  return visit(node);
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @returns {import("../types.mjs").RegexIR}
 */
function visit(node) {
  switch (node.kind) {
    case IR_NODE_KINDS.literal:
      return node;

    case IR_NODE_KINDS.concat:
      return concatNode(node.parts.map(visit));

    case IR_NODE_KINDS.optional:
      return optionalNode(visit(node.child));

    case IR_NODE_KINDS.altGroup:
      return normalizeAltGroup(node.alternatives.map(visit));

    default:
      return node;
  }
}

/**
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @returns {import("../types.mjs").RegexIR}
 */
function normalizeAltGroup(alternatives) {
  const emptyCount = alternatives.filter(isEmptyLiteral).length;

  if (emptyCount === 1 && alternatives.length >= 2) {
    const nonEmpty = alternatives.filter((alt) => !isEmptyLiteral(alt));
    if (nonEmpty.length === 0) return alternatives[0];

    return optionalNode(altGroupNode(nonEmpty, { force: true }));
  }

  return altGroupNode(alternatives, { force: true });
}
