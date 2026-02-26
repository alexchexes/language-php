import { IR_NODE_KINDS } from "../ir/types.mjs";
import {
  arrangePrettyAltBlocks,
  flattenAltBlocksToTexts,
} from "./layout.mjs";
import { escapeRegexLiteral, groupOpen, isAutoIndentMode } from "./shared.mjs";

/**
 * Render IR to compact regex while preserving the same alternative ordering
 * policy used by pretty mode.
 *
 * @param {import("../ir/types.mjs").RegexIR} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @returns {string}
 */
export function renderCompact(node, opts) {
  return emitNode(node, opts, {
    col: 0,
    lineCol: 0,
    wrapShift: 0,
  }).text;
}

/**
 * @typedef {{
 *   col: number,
 *   lineCol: number,
 *   wrapShift: number
 * }} RenderContext
 */

/**
 * @param {import("../ir/types.mjs").RegexIR} node
 * @param {{
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @returns {{ text: string, hasGroup: boolean }}
 */
function emitNode(node, opts, ctx) {
  switch (node.kind) {
    case IR_NODE_KINDS.literal:
      return { text: escapeRegexLiteral(node.value), hasGroup: false };

    case IR_NODE_KINDS.concat:
      return emitConcat(node, opts, ctx);

    case IR_NODE_KINDS.altGroup:
      return emitAltGroup(node, opts, ctx, false);

    case IR_NODE_KINDS.optional:
      return emitOptional(node, opts, ctx);

    default:
      return { text: "", hasGroup: false };
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
 * @returns {{ text: string, hasGroup: boolean }}
 */
function emitConcat(node, opts, ctx) {
  let text = "";
  let hasGroup = false;
  let currentCol = ctx.col;

  for (const part of node.parts) {
    if (part.kind === IR_NODE_KINDS.literal) {
      const escaped = escapeRegexLiteral(part.value);
      text += escaped;
      currentCol += escaped.length;
      continue;
    }

    const child = emitNode(part, opts, {
      col: currentCol,
      lineCol: ctx.lineCol,
      wrapShift: ctx.wrapShift + 1,
    });
    text += child.text;
    hasGroup = hasGroup || child.hasGroup;
    currentCol += child.text.length;
  }

  return { text, hasGroup };
}

/**
 * @param {{ kind: "altGroup", alternatives: import("../ir/types.mjs").RegexIR[] }} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @param {boolean} forceGroup
 * @returns {{ text: string, hasGroup: boolean }}
 */
function emitAltGroup(node, opts, ctx, forceGroup) {
  const indent = opts.indent;
  const wrapCol = opts.wrap;
  const groupStyle = opts.groupStyle;
  const autoIndent = isAutoIndentMode(indent);
  const indentSize = autoIndent ? 0 : indent;
  const innerCol = autoIndent ? ctx.col : ctx.lineCol + indentSize;
  const effectiveWrapCol = Math.max(1, wrapCol - ctx.wrapShift);

  const altCtx = {
    col: innerCol,
    lineCol: innerCol,
    wrapShift: ctx.wrapShift + 1,
  };

  const alts = node.alternatives.map((alt) => emitNode(alt, opts, altCtx));
  if (alts.length === 0) return { text: "", hasGroup: false };
  if (alts.length === 1 && !forceGroup) return alts[0];

  const arrangedBlocks = arrangePrettyAltBlocks(
    alts.map((alt) => ({
      text: alt.text,
      singleLine: true,
      hasGroup: alt.hasGroup,
    })),
  );
  const arranged = flattenAltBlocksToTexts(arrangedBlocks);

  return {
    text: `${groupOpen(groupStyle)}${arranged.join("|")})`,
    hasGroup: true,
  };
}

/**
 * @param {{ kind: "optional", child: import("../ir/types.mjs").RegexIR }} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @returns {{ text: string, hasGroup: boolean }}
 */
function emitOptional(node, opts, ctx) {
  const groupNode =
    node.child.kind === IR_NODE_KINDS.altGroup
      ? node.child
      : {
          kind: IR_NODE_KINDS.altGroup,
          alternatives: [node.child],
        };
  const child = emitAltGroup(groupNode, opts, ctx, true);

  return {
    text: `${child.text}?`,
    hasGroup: true,
  };
}
