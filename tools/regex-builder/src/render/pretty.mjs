import { IR_NODE_KINDS } from "../ir/types.mjs";
import {
  arrangePrettyAltBlocks,
  flattenAltBlocksToTexts,
  isSimpleInlineAlt,
  packSimpleAltTokens,
} from "./layout.mjs";
import {
  escapeRegexLiteral,
  groupOpen,
  isAutoIndentMode,
  makeEmitted,
} from "./shared.mjs";

/**
 * Render IR to pretty multiline regex.
 * @param {import("../ir/types.mjs").RegexIR} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @returns {string}
 */
export function renderPretty(node, opts) {
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
 * @returns {{ text: string, singleLine: boolean, hasGroup: boolean }}
 */
function emitNode(node, opts, ctx) {
  switch (node.kind) {
    case IR_NODE_KINDS.literal:
      return makeEmitted(escapeRegexLiteral(node.value), false);

    case IR_NODE_KINDS.concat:
      return emitConcat(node, opts, ctx);

    case IR_NODE_KINDS.altGroup:
      return emitAltGroup(node, opts, ctx, false);

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
 * @returns {{ text: string, singleLine: boolean, hasGroup: boolean }}
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
 * @param {{ kind: "altGroup", alternatives: import("../ir/types.mjs").RegexIR[] }} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @param {boolean} forceGroup
 * @returns {{ text: string, singleLine: boolean, hasGroup: boolean }}
 */
function emitAltGroup(node, opts, ctx, forceGroup) {
  const indent = opts.indent;
  const wrapCol = opts.wrap;
  const groupStyle = opts.groupStyle;
  const effectiveWrapCol = Math.max(1, wrapCol - ctx.wrapShift);
  const autoIndent = isAutoIndentMode(indent);
  const indentSize = autoIndent ? 0 : indent;
  const needsBareGroupIndent =
    autoIndent && ctx.wrapShift > 0 && ctx.col === ctx.lineCol;
  const innerCol = autoIndent
    ? ctx.col + (needsBareGroupIndent ? 1 : 0)
    : ctx.lineCol + indentSize;

  const altCtx = {
    col: innerCol,
    lineCol: innerCol,
    wrapShift: ctx.wrapShift + 1,
  };

  const alts = node.alternatives.map((alt) => emitNode(alt, opts, altCtx));

  if (alts.length === 0) return makeEmitted("", false);
  if (alts.length === 1 && !forceGroup) return alts[0];

  const open = groupOpen(groupStyle);
  if (alts.length === 1 && alts[0].singleLine) {
    return makeEmitted(`${open}${alts[0].text})`, true);
  }
  const arrangedBlocks = arrangePrettyAltBlocks(alts);
  const arrangedAltTexts = flattenAltBlocksToTexts(arrangedBlocks);

  const canInlineSimpleGroup = alts.every(isSimpleInlineAlt);
  if (canInlineSimpleGroup) {
    const inline = `${open}${arrangedAltTexts.join("|")})`;
    if (ctx.lineCol + inline.length <= effectiveWrapCol) {
      return makeEmitted(inline, true);
    }
  }

  const base = " ".repeat(ctx.lineCol);
  const inner = autoIndent ? " ".repeat(innerCol) : " ".repeat(innerCol);

  /** @type {string[]} */
  const lines = [open];
  let hasEmittedAlt = false;

  for (const block of arrangedBlocks) {
    if (block.type === "complex") {
      appendPrettyAltLines(lines, block.alt, !hasEmittedAlt, inner, autoIndent);
      hasEmittedAlt = true;
      continue;
    }

    if (block.tokens.length === 0) continue;

    const packed = packSimpleAltTokens(
      block.tokens,
      effectiveWrapCol,
      inner.length,
      !hasEmittedAlt,
    );

    for (const packedLine of packed) {
      const prefix = hasEmittedAlt ? `${inner}|` : inner;
      lines.push(prefix + packedLine);
      hasEmittedAlt = true;
    }
  }

  lines.push(base + ")");
  return makeEmitted(lines.join("\n"), true);
}

/**
 * @param {{ kind: "optional", child: import("../ir/types.mjs").RegexIR }} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @param {RenderContext} ctx
 * @returns {{ text: string, singleLine: boolean, hasGroup: boolean }}
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
  return makeEmitted(`${child.text}?`, true);
}

/**
 * @param {string[]} lines
 * @param {{ text: string, singleLine: boolean, hasGroup: boolean }} alt
 * @param {boolean} firstAltInGroup
 * @param {string} inner
 * @param {boolean} autoIndent
 */
function appendPrettyAltLines(lines, alt, firstAltInGroup, inner, autoIndent) {
  const prefix = firstAltInGroup ? inner : `${inner}|`;

  if (alt.singleLine) {
    lines.push(prefix + alt.text);
    return;
  }

  const parts = alt.text.split("\n");
  lines.push(prefix + parts[0]);

  for (let i = 1; i < parts.length; i += 1) {
    const isLastLineOfAlt = i === parts.length - 1;

    if (isLastLineOfAlt) {
      lines.push(inner + parts[i].replace(/^\s*/, ""));
      continue;
    }

    if (autoIndent) {
      const extraShift = firstAltInGroup ? 0 : 1;
      lines.push(" ".repeat(extraShift) + parts[i]);
    } else {
      lines.push(parts[i]);
    }
  }
}
