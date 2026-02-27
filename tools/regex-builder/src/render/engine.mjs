import { IR_NODE_KINDS } from "../ir/types.mjs";
import { escapeRegexLiteral, makeEmitted } from "./shared.mjs";

/**
 * @typedef {{
 *   col: number,
 *   lineCol: number,
 *   wrapShift: number
 * }} RenderContext
 */

/**
 * @typedef {{ text: string, singleLine: boolean, hasGroup: boolean }} Emitted
 */

/**
 * @callback EmitAltGroup
 * @param {{ kind: "altGroup", alternatives: import("../ir/types.mjs").RegexIR[] }} node
 * @param {{
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @param {boolean} forceGroup
 * @param {EmitNode} emitNode
 * @returns {Emitted}
 */

/**
 * @callback EmitNode
 * @param {import("../ir/types.mjs").RegexIR} node
 * @param {{
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @returns {Emitted}
 */

/**
 * Build a renderer from mode-specific alternative-group emitter.
 *
 * Shared logic here handles:
 * - node traversal
 * - concat context tracking
 * - optional-group normalization
 *
 * @param {EmitAltGroup} emitAltGroup
 * @returns {{ render: (node: import("../ir/types.mjs").RegexIR, opts: {
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }) => string, emitNode: EmitNode }}
 */
export function makeRenderer(emitAltGroup) {
  /**
   * @type {EmitNode}
   */
  function emitNode(node, opts, ctx) {
    switch (node.kind) {
      case IR_NODE_KINDS.literal:
        return makeEmitted(escapeRegexLiteral(node.value), false);

      case IR_NODE_KINDS.concat:
        return emitConcat(node, opts, ctx);

      case IR_NODE_KINDS.altGroup:
        return emitAltGroup(node, opts, ctx, false, emitNode);

      case IR_NODE_KINDS.optional:
        return emitOptional(node, opts, ctx);

      default:
        return makeEmitted("", false);
    }
  }

  /**
   * @param {{ kind: "concat", parts: import("../ir/types.mjs").RegexIR[] }} node
   * @param {{
   *   indent: number | "auto",
   *   wrap: number,
   *   groupStyle: "capturing" | "noncapturing"
   * }} opts
   * @param {RenderContext} ctx
   * @returns {Emitted}
   */
  function emitConcat(node, opts, ctx) {
    let text = "";
    let hasGroup = false;
    let currentCol = ctx.col;
    let currentLineCol = ctx.lineCol;

    for (const part of node.parts) {
      if (part.kind === IR_NODE_KINDS.literal) {
        const escaped = escapeRegexLiteral(part.value);
        text += escaped;
        currentCol += escaped.length;
        continue;
      }

      const child = emitNode(part, opts, {
        col: currentCol,
        lineCol: currentLineCol,
        wrapShift: ctx.wrapShift + 1,
      });

      text += child.text;
      hasGroup = hasGroup || child.hasGroup;

      if (child.singleLine) {
        currentCol += child.text.length;
        continue;
      }

      const lines = child.text.split("\n");
      const lastLine = lines[lines.length - 1];
      currentCol = lastLine.length;
      const lineStartMatch = /^\s*/.exec(lastLine);
      currentLineCol = lineStartMatch ? lineStartMatch[0].length : 0;
    }

    return makeEmitted(text, hasGroup);
  }

  /**
   * @param {{ kind: "optional", child: import("../ir/types.mjs").RegexIR }} node
   * @param {{
   *   indent: number | "auto",
   *   wrap: number,
   *   groupStyle: "capturing" | "noncapturing"
   * }} opts
   * @param {RenderContext} ctx
   * @returns {Emitted}
   */
  function emitOptional(node, opts, ctx) {
    const groupNode =
      node.child.kind === IR_NODE_KINDS.altGroup
        ? node.child
        : {
            kind: IR_NODE_KINDS.altGroup,
            alternatives: [node.child],
          };

    const child = emitAltGroup(groupNode, opts, ctx, true, emitNode);
    return makeEmitted(`${child.text}?`, true);
  }

  /**
   * @param {import("../ir/types.mjs").RegexIR} node
   * @param {{
   *   indent: number | "auto",
   *   wrap: number,
   *   groupStyle: "capturing" | "noncapturing"
   * }} opts
   * @returns {string}
   */
  function render(node, opts) {
    return emitNode(node, opts, {
      col: 0,
      lineCol: 0,
      wrapShift: 0,
    }).text;
  }

  return { render, emitNode };
}
