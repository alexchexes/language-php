import { makeRenderer } from "./engine.mjs";
import {
  arrangePrettyAltBlocks,
  flattenAltBlocksToTexts,
} from "./layout.mjs";
import { groupOpen, isAutoIndentMode, makeEmitted } from "./shared.mjs";

const { render } = makeRenderer(emitAltGroup);

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
  const groupStyle = opts.groupStyle;
  const autoIndent = isAutoIndentMode(indent);
  const indentSize = autoIndent ? 0 : indent;
  const innerCol = autoIndent ? ctx.col : ctx.lineCol + indentSize;

  const altCtx = {
    col: innerCol,
    lineCol: innerCol,
    wrapShift: ctx.wrapShift + 1,
  };

  const alts = node.alternatives.map((alt) => emitNode(alt, opts, altCtx));
  if (alts.length === 0) return makeEmitted("", false);
  if (alts.length === 1 && !forceGroup) return alts[0];

  const arrangedBlocks = arrangePrettyAltBlocks(
    alts.map((alt) => ({
      text: alt.text,
      singleLine: true,
      hasGroup: alt.hasGroup,
    })),
  );
  const arranged = flattenAltBlocksToTexts(arrangedBlocks);

  return makeEmitted(`${groupOpen(groupStyle)}${arranged.join("|")})`, true);
}
