import { IR_NODE_KINDS } from "../../types.mjs";
import { concatNode, literalNode } from "../../node-utils.mjs";

/**
 * @param {import("../../types.mjs").RegexIR} node
 * @returns {string | null}
 */
export function getLeadingLiteral(node) {
  if (node.kind === IR_NODE_KINDS.literal) return node.value;

  if (node.kind === IR_NODE_KINDS.concat) {
    let value = "";

    for (const part of node.parts) {
      if (part.kind !== IR_NODE_KINDS.literal) break;
      value += part.value;
    }

    return value.length > 0 ? value : null;
  }

  return null;
}

/**
 * @param {import("../../types.mjs").RegexIR} node
 * @returns {string | null}
 */
export function getWholeLiteralValue(node) {
  if (node.kind === IR_NODE_KINDS.literal) return node.value;
  if (node.kind !== IR_NODE_KINDS.concat) return null;

  let value = "";
  for (const part of node.parts) {
    if (part.kind !== IR_NODE_KINDS.literal) return null;
    value += part.value;
  }

  return value;
}

/**
 * @param {import("../../types.mjs").RegexIR} node
 * @param {string} prefix
 * @returns {import("../../types.mjs").RegexIR}
 */
export function removePrefixFromLeadingLiteral(node, prefix) {
  if (node.kind === IR_NODE_KINDS.literal) {
    return literalNode(node.value.slice(prefix.length));
  }

  if (node.kind === IR_NODE_KINDS.concat) {
    if (prefix.length === 0) return node;

    let remaining = prefix.length;
    let index = 0;
    /** @type {import("../../types.mjs").RegexIR[]} */
    const outParts = [];

    while (index < node.parts.length && remaining > 0) {
      const part = node.parts[index];
      if (part.kind !== IR_NODE_KINDS.literal) return node;

      if (part.value.length <= remaining) {
        remaining -= part.value.length;
        index += 1;
        continue;
      }

      outParts.push(literalNode(part.value.slice(remaining)));
      remaining = 0;
      index += 1;
      break;
    }

    if (remaining > 0) return node;
    outParts.push(...node.parts.slice(index));
    return concatNode(outParts);
  }

  return node;
}

