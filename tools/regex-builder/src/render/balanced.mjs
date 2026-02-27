import { IR_NODE_KINDS } from "../ir/types.mjs";
import { renderCompact } from "./compact.mjs";
import { makeRenderer } from "./engine.mjs";
import {
  arrangePrettyAltBlocks,
  flattenAltBlocksToTexts,
} from "./layout.mjs";
import { groupOpen, isAutoIndentMode, makeEmitted } from "./shared.mjs";

const { render } = makeRenderer(emitAltGroup);

/**
 * Render IR to balanced multiline regex:
 * - keep alternatives inline as long as wrap allows,
 * - break by `|` when needed,
 * - treat nested groups as atomic alternatives before splitting inside them.
 *
 * Removing whitespace from this output keeps the exact compact regex.
 *
 * @param {import("../ir/types.mjs").RegexIR} node
 * @param {{
 *   indent: number | "auto",
 *   wrap: number,
 *   groupStyle: "capturing" | "noncapturing"
 * }} opts
 * @returns {string}
 */
export function renderBalanced(node, opts) {
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
  if (node.alternatives.length === 0) return makeEmitted("", false);

  if (node.alternatives.length === 1 && !forceGroup) {
    return emitNode(node.alternatives[0], opts, {
      col: ctx.col,
      lineCol: ctx.lineCol,
      wrapShift: ctx.wrapShift + 1,
    });
  }

  const indent = opts.indent;
  const wrapCol = opts.wrap;
  const groupStyle = opts.groupStyle;
  const autoIndent = isAutoIndentMode(indent);
  const indentSize = autoIndent ? 0 : indent;
  const effectiveWrapCol = Math.max(1, wrapCol - ctx.wrapShift);
  const open = groupOpen(groupStyle);
  const close = ")";

  const continuationPipeCol = autoIndent ? ctx.col : ctx.lineCol + indentSize;
  const continuationAltCol = continuationPipeCol + 1;
  const firstAltCol = ctx.col + open.length;
  const continuationIndent = " ".repeat(continuationPipeCol);
  const baseIndent = " ".repeat(ctx.lineCol);

  const inlineEntries = node.alternatives.map((altNode) => ({
    node: altNode,
    inline: renderCompact(altNode, opts),
    hasGroup: hasStructuralGroup(altNode),
  }));

  const arrangedBlocks = arrangePrettyAltBlocks(
    inlineEntries.map((entry) => ({
      text: entry,
      singleLine: true,
      hasGroup: entry.hasGroup,
    })),
  );
  const orderedEntries = flattenAltBlocksToTexts(arrangedBlocks);

  const inlineWhole = `${open}${orderedEntries.map((entry) => entry.inline).join("|")})`;
  if (ctx.col + inlineWhole.length <= effectiveWrapCol) {
    return makeEmitted(inlineWhole, true);
  }

  /** @type {string[]} */
  const lines = [];
  let currentInlineLine = "";
  let currentLineHasComplex = false;
  let currentLineLargestComplexLen = 0;
  let currentStartCol = firstAltCol;
  let isFirstLine = true;

  const flushInlineLine = () => {
    if (currentInlineLine === "") return;

    if (isFirstLine) {
      lines.push(open + currentInlineLine);
    } else {
      lines.push(`${continuationIndent}|${currentInlineLine}`);
    }

    currentInlineLine = "";
    currentLineHasComplex = false;
    currentLineLargestComplexLen = 0;
    currentStartCol = continuationAltCol;
    isFirstLine = false;
  };

  for (const entry of orderedEntries) {
    const token = entry.inline;

    if (currentInlineLine !== "") {
      const candidate = `${currentInlineLine}|${token}`;
      const lineCapacity = Math.max(1, effectiveWrapCol - currentStartCol);
      const isolateLargeComplex =
        currentLineHasComplex &&
        !entry.hasGroup &&
        currentLineLargestComplexLen / lineCapacity >= 0.35;
      const reserveLargeComplexLine =
        entry.hasGroup &&
        !currentLineHasComplex &&
        token.length / lineCapacity >= 0.35 &&
        currentInlineLine.length / lineCapacity >= 0.35;

      if (
        !isolateLargeComplex &&
        !reserveLargeComplexLine &&
        currentStartCol + candidate.length <= effectiveWrapCol
      ) {
        currentInlineLine = candidate;
        if (entry.hasGroup) {
          currentLineHasComplex = true;
          currentLineLargestComplexLen = Math.max(
            currentLineLargestComplexLen,
            token.length,
          );
        }
        continue;
      }
      flushInlineLine();
    }

    if (currentStartCol + token.length <= effectiveWrapCol) {
      currentInlineLine = token;
      currentLineHasComplex = entry.hasGroup;
      currentLineLargestComplexLen = entry.hasGroup ? token.length : 0;
      continue;
    }

    const altCol = isFirstLine ? firstAltCol : continuationAltCol;
    const wrappedAlt = emitNode(entry.node, opts, {
      col: altCol,
      lineCol: altCol,
      wrapShift: ctx.wrapShift + 1,
    });

    appendBalancedAltLines(
      lines,
      wrappedAlt.text,
      isFirstLine,
      open,
      continuationIndent,
    );
    currentInlineLine = "";
    currentLineHasComplex = false;
    currentLineLargestComplexLen = 0;
    currentStartCol = continuationAltCol;
    isFirstLine = false;
  }

  flushInlineLine();

  if (lines.length === 0) {
    lines.push(open);
  }

  const lastIndex = lines.length - 1;
  if (lines[lastIndex].length + close.length <= effectiveWrapCol) {
    lines[lastIndex] += close;
  } else {
    lines.push(baseIndent + close);
  }

  return makeEmitted(lines.join("\n"), true);
}

/**
 * @param {string[]} lines
 * @param {string} text
 * @param {boolean} firstAltInGroup
 * @param {string} open
 * @param {string} continuationIndent
 */
function appendBalancedAltLines(
  lines,
  text,
  firstAltInGroup,
  open,
  continuationIndent,
) {
  const parts = text.split("\n");
  if (firstAltInGroup) {
    lines.push(open + parts[0]);
  } else {
    lines.push(`${continuationIndent}|${parts[0]}`);
  }

  for (let i = 1; i < parts.length; i += 1) {
    lines.push(parts[i]);
  }
}

/**
 * @param {import("../ir/types.mjs").RegexIR} node
 * @returns {boolean}
 */
function hasStructuralGroup(node) {
  switch (node.kind) {
    case IR_NODE_KINDS.literal:
      return false;

    case IR_NODE_KINDS.concat:
      return node.parts.some(hasStructuralGroup);

    case IR_NODE_KINDS.altGroup:
    case IR_NODE_KINDS.optional:
      return true;

    default:
      return false;
  }
}
