import { makeRenderer } from "./engine.mjs";
import {
  arrangePrettyAltBlocks,
  flattenAltBlocksToTexts,
  isSimpleInlineAlt,
  packSimpleAltTokens,
} from "./layout.mjs";
import { groupOpen, isAutoIndentMode, makeEmitted } from "./shared.mjs";

const { render } = makeRenderer(emitAltGroup);

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
  return render(node, opts);
}

/**
 * @param {{ kind: "altGroup", alternatives: import("../ir/types.mjs").RegexIR[] }} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @param {{ col: number, lineCol: number, wrapShift: number }} ctx
 * @param {boolean} forceGroup
 * @param {(node: import("../ir/types.mjs").RegexIR, opts: {
 *   indent?: number | "auto",
 *   wrap?: number,
 *   groupStyle?: "capturing" | "noncapturing"
 * }, ctx: { col: number, lineCol: number, wrapShift: number }) => {
 *   text: string, singleLine: boolean, hasGroup: boolean
 * }} emitNode
 * @returns {{ text: string, singleLine: boolean, hasGroup: boolean }}
 */
function emitAltGroup(node, opts, ctx, forceGroup, emitNode) {
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
  const inner = " ".repeat(innerCol);

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
