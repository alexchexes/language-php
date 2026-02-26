import { IR_NODE_KINDS } from "./types.mjs";

export function literalNode(value) {
  return { kind: IR_NODE_KINDS.literal, value };
}

export function isLiteralNode(node) {
  return node && node.kind === IR_NODE_KINDS.literal;
}

export function isEmptyLiteral(node) {
  return isLiteralNode(node) && node.value === "";
}

export function concatNode(parts) {
  const flattened = [];

  for (const part of parts) {
    if (!part) continue;

    if (part.kind === IR_NODE_KINDS.concat) {
      flattened.push(...part.parts);
      continue;
    }

    flattened.push(part);
  }

  const compact = flattened.filter((part) => !isEmptyLiteral(part));
  if (compact.length === 0) return literalNode("");
  if (compact.length === 1) return compact[0];

  return { kind: IR_NODE_KINDS.concat, parts: compact };
}

export function altGroupNode(alternatives, { force = false } = {}) {
  if (!force && alternatives.length === 1) return alternatives[0];
  return { kind: IR_NODE_KINDS.altGroup, alternatives };
}

export function optionalNode(child) {
  return { kind: IR_NODE_KINDS.optional, child };
}
