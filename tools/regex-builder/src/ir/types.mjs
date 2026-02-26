/**
 * @typedef {{ kind: "literal", value: string }} LiteralNode
 * @typedef {{ kind: "concat", parts: RegexIR[] }} ConcatNode
 * @typedef {{ kind: "altGroup", alternatives: RegexIR[] }} AltGroupNode
 * @typedef {{ kind: "optional", child: RegexIR }} OptionalNode
 * @typedef {LiteralNode | ConcatNode | AltGroupNode | OptionalNode} RegexIR
 */

export const IR_NODE_KINDS = Object.freeze({
  literal: "literal",
  concat: "concat",
  altGroup: "altGroup",
  optional: "optional",
});
