// Written by LLM

// Usage:
//   node regex-builder.mjs input.txt
//   node regex-builder.mjs input.txt --compact
//   node regex-builder.mjs input.txt --json
//   node regex-builder.mjs input.txt --noncapturing
//
// Input format:
//   newline-separated literal strings
//   (lines may optionally start with "|" and whitespace)
//
// Example line:
//   |IDNA_ERROR_BIDI

import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

/** @typedef {{ terminal: boolean, children: Map<string, TrieNode> }} TrieNode */
/** @typedef {{ terminal: boolean, edges: Array<{ label: string, node: CompNode }> }} CompNode */

/* ----------------------------- Parsing helpers ----------------------------- */

function parseInputLines(text) {
  return text
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((line) => line.trim())
    .map((line) => line.replace(/^\|+\s*/, "")) // allow regex-style pasted alternations
    .filter(Boolean);
}

function uniqueStable(arr) {
  const seen = new Set();
  const out = [];
  for (const x of arr) {
    if (!seen.has(x)) {
      seen.add(x);
      out.push(x);
    }
  }
  return out;
}

/* ------------------------------- Trie builder ------------------------------ */

function createTrieNode() {
  return { terminal: false, children: new Map() };
}

/**
 * Build a character trie from a list of literal strings.
 * @param {string[]} strings
 * @returns {TrieNode}
 */
export function buildTrie(strings) {
  const root = createTrieNode();

  for (const s of strings) {
    let node = root;
    for (const ch of s) {
      if (!node.children.has(ch)) {
        node.children.set(ch, createTrieNode());
      }
      node = node.children.get(ch);
    }
    node.terminal = true;
  }

  return root;
}

/* ----------------------------- Trie compression ---------------------------- */

/**
 * Compress single-child chains into edge labels.
 * Keeps terminal boundaries intact.
 * @param {TrieNode} node
 * @returns {CompNode}
 */
export function compressTrie(node) {
  /** @type {CompNode} */
  const out = { terminal: node.terminal, edges: [] };

  // Sort for deterministic output
  const entries = [...node.children.entries()].sort((a, b) =>
    a[0].localeCompare(b[0]),
  );

  for (const [ch, child] of entries) {
    let label = ch;
    let n = child;

    // Collapse while there is exactly one child and current node is not terminal
    while (!n.terminal && n.children.size === 1) {
      const [[nextCh, nextNode]] = [...n.children.entries()];
      label += nextCh;
      n = nextNode;
    }

    out.edges.push({ label, node: compressTrie(n) });
  }

  return out;
}

/* ------------------------------ Tree debugging ----------------------------- */

/**
 * JSON-friendly representation (useful for inspection/debugging)
 * @param {CompNode} node
 * @returns {any}
 */
export function compTrieToObject(node) {
  const obj = {};
  if (node.terminal) obj.$ = true;
  for (const edge of node.edges) {
    obj[edge.label] = compTrieToObject(edge.node);
  }
  return obj;
}

/* ------------------------------- Regex emitter ----------------------------- */

function escapeRegexLiteral(s) {
  // Escape regex metacharacters for literal matching.
  return s.replace(/[\\^$.*+?()[\]{}|]/g, "\\$&");
}

/**
 * @typedef {{
 *   pretty?: boolean,
 *   indent?: number | 'auto',
 *   wrap?: number,
 *   groupStyle?: 'capturing' | 'noncapturing',
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>
 * }} EmitOptions
 */

/**
 * @typedef {{
 *   text: string,
 *   singleLine: boolean,
 *   hasGroup: boolean
 * }} Emitted
 */

/**
 * @typedef {{
 *   wordTailLen: number,      // chars since last underscore
 *   wordTail: string,         // current word segment suffix since last underscore
 *   lastChar: string | null
 * }} SplitState
 */

function groupOpen(groupStyle) {
  return groupStyle === "noncapturing" ? "(?:" : "(";
}

function indentStr(level, size) {
  return " ".repeat(level * size);
}

function isAutoIndentMode(indent) {
  return indent === "auto";
}

/**
 * @param {string} text
 * @param {boolean} hasGroup
 * @returns {Emitted}
 */
function makeEmitted(text, hasGroup) {
  return {
    text,
    singleLine: !text.includes("\n"),
    hasGroup,
  };
}

/**
 * Advance split-state through a raw (unescaped) edge label.
 * @param {SplitState} state
 * @param {string} rawLabel
 * @returns {SplitState}
 */
function advanceSplitState(state, rawLabel) {
  let wordTailLen = state.wordTailLen;
  let wordTail = state.wordTail;
  let lastChar = state.lastChar;

  for (const ch of rawLabel) {
    lastChar = ch;
    if (ch === "_") {
      wordTailLen = 0;
      wordTail = "";
    } else {
      wordTailLen += 1;
      wordTail += ch;
    }
  }

  return { wordTailLen, wordTail, lastChar };
}

/**
 * Direct alt-count of a CompNode before any formatting.
 * @param {CompNode} node
 * @returns {number}
 */
function directAltCount(node) {
  return (node.terminal ? 1 : 0) + node.edges.length;
}

/**
 * Whether child has an immediate branch starting with underscore.
 * (Useful to allow splits like E(_(... )|RROR_(...)) even if "E" is short.)
 * @param {CompNode} node
 * @returns {boolean}
 */
function hasImmediateUnderscoreBranch(node) {
  return node.edges.some((e) => e.label.startsWith("_"));
}

/**
 * Return true if any forbidden fragment has `prefix` as a strict prefix.
 * (Strict prefix because splitting *after* the full fragment is allowed.)
 * @param {Set<string> | undefined} forbidSet
 * @param {string} prefix
 * @returns {boolean}
 */
function hasForbiddenFragmentWithStrictPrefix(forbidSet, prefix) {
  if (!forbidSet || forbidSet.size === 0) return false;
  for (const w of forbidSet) {
    if (w.length > prefix.length && w.startsWith(prefix)) return true;
  }
  return false;
}

/**
 * Return true if there exists a path from compressed node `node` whose next chars
 * begin with `wanted` (exactly), allowing the match to end in the middle of an edge.
 *
 * This checks "can descendants continue current split prefix into a forbidden fragment?"
 *
 * @param {CompNode} node
 * @param {string} wanted
 * @returns {boolean}
 */
function nodeHasPathPrefix(node, wanted) {
  if (wanted.length === 0) return true;

  for (const edge of node.edges) {
    const label = edge.label;
    let i = 0;
    const max = Math.min(label.length, wanted.length);

    while (i < max && label[i] === wanted[i]) i++;

    // No match on this edge
    if (i === 0) continue;

    // Consumed all wanted chars (possibly in the middle of the edge)
    if (i === wanted.length) return true;

    // Consumed whole edge label, continue into child
    if (i === label.length) {
      if (nodeHasPathPrefix(edge.node, wanted.slice(i))) return true;
    }

    // Otherwise mismatch in the middle of edge -> this edge cannot satisfy `wanted`
  }

  return false;
}

/**
 * Mid-word split blacklist rule:
 * If the split is inside a word, and the split would cut through any forbidden
 * fragment, then factoring is disallowed at this split point.
 *
 * Example:
 *   --no-split STANDAR
 *   blocks: STA(NDAR...)
 *   allows: STANDAR(...)
 *
 * @param {CompNode} childNode
 * @param {SplitState} afterPrefixState
 * @param {EmitOptions} opts
 * @returns {boolean}
 */
function isForbiddenMidwordSplitByWordBlacklist(
  childNode,
  afterPrefixState,
  opts,
) {
  const forbidSet = opts.forbidSplitWords;
  if (!forbidSet || forbidSet.size === 0) return false;

  // "_" boundary splits are explicitly allowed.
  if (afterPrefixState.lastChar === "_") return false;

  // If underscore is immediately one branch away, caller will allow factoring;
  // this is not considered "splitting the current fragment" (e.g. STANDARD(_(...))?).
  if (hasImmediateUnderscoreBranch(childNode)) return false;

  const prefix = afterPrefixState.wordTail;

  // Fast reject
  if (!hasForbiddenFragmentWithStrictPrefix(forbidSet, prefix)) return false;

  for (const frag of forbidSet) {
    if (!(frag.length > prefix.length && frag.startsWith(prefix))) continue;

    const remainder = frag.slice(prefix.length);
    if (nodeHasPathPrefix(childNode, remainder)) {
      return true;
    }
  }

  return false;
}

/**
 * Policy: can we factor at this split point (i.e. emit PREFIX(child-group))?
 * If false, caller should flatten one level instead of introducing a short/ugly split.
 *
 * @param {CompNode} childNode
 * @param {SplitState} afterPrefixState
 * @param {EmitOptions} opts
 * @returns {boolean}
 */
function canFactorAfterPrefix(childNode, afterPrefixState, opts) {
  const minWordSplitLen = opts.minWordSplitLen ?? 3;

  // Split exactly at underscore boundary is always OK: ERROR_(...)
  if (afterPrefixState.lastChar === "_") return true;

  // If underscore is immediately one branch away, also OK: E(_(... )|RROR_(...))
  if (hasImmediateUnderscoreBranch(childNode)) return true;

  // Fragment blacklist for mid-word splits.
  if (
    isForbiddenMidwordSplitByWordBlacklist(childNode, afterPrefixState, opts)
  ) {
    return false;
  }

  if (minWordSplitLen <= 0) return true;

  // Otherwise require enough chars in the current word tail.
  return afterPrefixState.wordTailLen >= minWordSplitLen;
}

/**
 * Return direct alternatives for a node *without* wrapping this node in a group.
 * Each returned alt may already contain deeper groups.
 *
 * This function enforces the "minimum word split length" rule by deciding whether
 * to factor at edge->child boundary or flatten one level.
 *
 * @param {CompNode} node
 * @param {EmitOptions} opts
 * @param {number} level
 * @param {SplitState} state
 * @param {number} col      Break column for this node (used by auto-indent mode)
 * @param {number} lineCol  Opening-line indent column for this node
 * @param {number} wrapShift Conservative wrap adjustment for nested pretty rendering
 * @returns {Emitted[]}
 */
function emitNodeAlts(node, opts, level, state, col, lineCol, wrapShift) {
  /** @type {Emitted[]} */
  const alts = [];

  if (node.terminal) {
    alts.push(makeEmitted("", false));
  }

  for (const edge of node.edges) {
    const rawLabel = edge.label;
    const label = escapeRegexLiteral(rawLabel);
    const afterPrefixState = advanceSplitState(state, rawLabel);

    const indent = opts.indent ?? 2;
    const autoIndent = isAutoIndentMode(indent);
    const indentSize = autoIndent ? 0 : indent;

    // Parent's alternatives in this node start at:
    // - `col` in auto mode
    // - `lineCol + indent` in fixed-indent mode
    const currentAltIndentCol = autoIndent ? col : lineCol + indentSize;

    // Child group (emitted after this edge label) opens on the current alt line.
    // Its closing ')' should align to the current alt indentation (without branch '|').
    const childLineCol = currentAltIndentCol;

    // Child break column is where the child group's "(" sits after the edge label.
    const childCol = currentAltIndentCol + label.length;

    const childAltCount = directAltCount(edge.node);

    // No alternation in child => just append child as plain suffix
    if (childAltCount <= 1) {
      const childRendered = emitNode(
        edge.node,
        opts,
        level + 1,
        afterPrefixState,
        childCol,
        childLineCol,
        wrapShift + 1,
      );
      alts.push(
        makeEmitted(label + childRendered.text, childRendered.hasGroup),
      );
      continue;
    }

    // Child alternates. Either factor here, or flatten one level.
    if (canFactorAfterPrefix(edge.node, afterPrefixState, opts)) {
      const childRendered = emitNode(
        edge.node,
        opts,
        level + 1,
        afterPrefixState,
        childCol,
        childLineCol,
        wrapShift + 1,
      );
      alts.push(
        makeEmitted(label + childRendered.text, childRendered.hasGroup),
      );
    } else {
      // Flatten one level: PREFIX(a|b|c) => PREFIXa|PREFIXb|PREFIXc
      // Do not increase fixed indentation when flattening (no group was opened).
      // In auto mode we keep column-based alignment behavior unchanged.
      const flattenedLineCol = autoIndent ? childLineCol : lineCol;
      const childAlts = emitNodeAlts(
        edge.node,
        opts,
        level + 1,
        afterPrefixState,
        childCol,
        flattenedLineCol,
        wrapShift + 1,
      );
      for (const childAlt of childAlts) {
        alts.push(makeEmitted(label + childAlt.text, childAlt.hasGroup));
      }
    }
  }

  return alts;
}

/**
 * @param {Emitted} alt
 * @returns {boolean}
 */
function isSimpleInlineAlt(alt) {
  return alt.singleLine && !alt.hasGroup;
}

/**
 * @param {Emitted[]} alts
 * @returns {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>}
 */
function buildPrettyAltBlocks(alts) {
  /** @type {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} */
  const blocks = [];

  for (const alt of alts) {
    if (!isSimpleInlineAlt(alt)) {
      blocks.push({ type: "complex", alt });
      continue;
    }

    const prev = blocks[blocks.length - 1];
    if (prev && prev.type === "simple") {
      prev.tokens.push(alt.text);
    } else {
      blocks.push({ type: "simple", tokens: [alt.text] });
    }
  }

  return blocks;
}

/**
 * @param {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} blockIndex
 * @returns {boolean}
 */
function isFirstOutputBlock(blocks, blockIndex) {
  for (let i = 0; i < blockIndex; i++) {
    const b = blocks[i];
    if (b.type === "complex") return false;
    if (b.type === "simple" && b.tokens.length > 0) return false;
  }
  return true;
}

/**
 * @param {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} index
 * @returns {number}
 */
function findPrevSimpleBlockIndex(blocks, index) {
  for (let i = index - 1; i >= 0; i--) {
    const b = blocks[i];
    if (b.type === "simple" && b.tokens.length > 0) return i;
  }
  return -1;
}

/**
 * @param {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} index
 * @returns {number}
 */
function findNextSimpleBlockIndex(blocks, index) {
  for (let i = index + 1; i < blocks.length; i++) {
    const b = blocks[i];
    if (b.type === "simple" && b.tokens.length > 0) return i;
  }
  return -1;
}

/**
 * Pack simple alternatives into wrapped line payloads (without indentation/prefix).
 *
 * @param {string[]} tokens
 * @param {number} wrapCol
 * @param {number} innerCol
 * @param {boolean} firstLineHasNoPipe
 * @returns {string[]}
 */
function packSimpleAltTokens(tokens, wrapCol, innerCol, firstLineHasNoPipe) {
  if (tokens.length === 0) return [];

  /** @type {string[]} */
  const packed = [];
  let current = "";
  let currentLineHasNoPipe = firstLineHasNoPipe;

  for (const token of tokens) {
    if (current === "") {
      current = token;
      continue;
    }

    const prefixLen = innerCol + (currentLineHasNoPipe ? 0 : 1);
    const candidate = `${current}|${token}`;

    if (prefixLen + candidate.length <= wrapCol) {
      current = candidate;
      continue;
    }

    packed.push(current);
    current = token;
    currentLineHasNoPipe = false;
  }

  if (current !== "") {
    packed.push(current);
  }

  return packed;
}

/**
 * @param {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} blockIndex
 * @param {string} token
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {boolean}
 */
function canAppendTokenToSimpleBlock(
  blocks,
  blockIndex,
  token,
  wrapCol,
  innerCol,
) {
  const block = blocks[blockIndex];
  if (!block || block.type !== "simple" || block.tokens.length === 0) return false;

  const firstLineHasNoPipe = isFirstOutputBlock(blocks, blockIndex);
  const packed = packSimpleAltTokens(
    block.tokens,
    wrapCol,
    innerCol,
    firstLineHasNoPipe,
  );
  if (packed.length === 0) return false;

  const lastLine = packed[packed.length - 1];
  const lastPrefixLen =
    innerCol + (firstLineHasNoPipe && packed.length === 1 ? 0 : 1);

  return lastPrefixLen + lastLine.length + 1 + token.length <= wrapCol;
}

/**
 * Move singleton simple blocks into nearby simple blocks to avoid isolated leftovers.
 *
 * @param {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>}
 */
function rebalanceSingletonSimpleBlocks(blocks, wrapCol, innerCol) {
  for (let i = 0; i < blocks.length; i++) {
    const block = blocks[i];
    if (block.type !== "simple" || block.tokens.length !== 1) continue;

    const token = block.tokens[0];
    const prevSimpleIndex = findPrevSimpleBlockIndex(blocks, i);

    if (
      prevSimpleIndex !== -1 &&
      canAppendTokenToSimpleBlock(
        blocks,
        prevSimpleIndex,
        token,
        wrapCol,
        innerCol,
      )
    ) {
      blocks[prevSimpleIndex].tokens.push(token);
      blocks.splice(i, 1);
      i -= 1;
      continue;
    }

    const nextSimpleIndex = findNextSimpleBlockIndex(blocks, i);
    if (nextSimpleIndex !== -1) {
      blocks[nextSimpleIndex].tokens.unshift(token);
      blocks.splice(i, 1);
      i -= 1;
    }
  }

  return blocks;
}

/**
 * Arrange alternatives into simple/complex blocks using the same ordering rules
 * that pretty mode relies on (including singleton rebalance).
 *
 * @param {Emitted[]} alts
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>}
 */
function arrangePrettyAltBlocks(alts, wrapCol, innerCol) {
  let blocks = buildPrettyAltBlocks(alts);
  const hasSimpleBlock = blocks.some(
    (b) => b.type === "simple" && b.tokens.length > 0,
  );
  const hasComplexBlock = blocks.some((b) => b.type === "complex");

  if (hasSimpleBlock && hasComplexBlock) {
    blocks = rebalanceSingletonSimpleBlocks(blocks, wrapCol, innerCol);
  }

  return blocks;
}

/**
 * Flatten arranged blocks to a linear alt text list.
 *
 * @param {Array<{ type: "complex", alt: Emitted } | { type: "simple", tokens: string[] }>} blocks
 * @returns {string[]}
 */
function flattenAltBlocksToTexts(blocks) {
  /** @type {string[]} */
  const out = [];
  for (const block of blocks) {
    if (block.type === "complex") {
      out.push(block.alt.text);
      continue;
    }
    out.push(...block.tokens);
  }
  return out;
}

/**
 * @param {string[]} lines
 * @param {Emitted} alt
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

  for (let j = 1; j < parts.length; j++) {
    const isLastLineOfAlt = j === parts.length - 1;

    if (isLastLineOfAlt) {
      lines.push(inner + parts[j].replace(/^\s*/, ""));
      continue;
    }

    if (autoIndent) {
      const extraShift = firstAltInGroup ? 0 : 1;
      lines.push(" ".repeat(extraShift) + parts[j]);
    } else {
      lines.push(parts[j]);
    }
  }
}

/**
 * Emit suffix regex represented by this compressed trie node.
 *
 * Pretty-mode formatting rule:
 * - A group is rendered on one line iff every alternative is:
 *   (1) single-line, and
 *   (2) group-free (contains no nested formatter-emitted group).
 *
 * This prevents "double-nested groups on one line", e.g.:
 *   (AD_SPECIFIERS|ER(CENT_SYMBOLS|MILL_SYMBOLS)|OST_CONTEXTS)
 * while still allowing:
 *   ER(CENT_SYMBOLS|MILL_SYMBOLS)
 *
 * @param {CompNode} node
 * @param {EmitOptions} opts
 * @param {number} level
 * @param {SplitState} state
 * @param {number} col      Break column for this group (where inner alts align in auto mode)
 * @param {number} lineCol  Line-start indent column for this group's opening line (where closing ')' aligns in auto mode)
 * @param {number} wrapShift Conservative wrap adjustment for nested pretty rendering
 * @returns {Emitted}
 */
function emitNode(node, opts, level, state, col, lineCol, wrapShift) {
  const pretty = !!opts.pretty;
  const indent = opts.indent ?? 2;
  const wrapCol = opts.wrap ?? 100;
  const effectiveWrapCol = Math.max(1, wrapCol - wrapShift);
  const autoIndent = isAutoIndentMode(indent);
  const indentSize = autoIndent ? 0 : indent;
  const innerCol = autoIndent ? col : lineCol + indentSize;
  const groupStyle = opts.groupStyle ?? "capturing";

  const alts = emitNodeAlts(node, opts, level, state, col, lineCol, wrapShift);

  if (alts.length === 0) return makeEmitted("", false);
  if (alts.length === 1) return alts[0];

  const open = groupOpen(groupStyle);

  const emptyCount = alts.filter((a) => a.text === "").length;
  // Normalize a single empty alternative in any-size group:
  //   (|A|B|C) => (A|B|C)?
  // This avoids emitting bare empty-branch syntax and produces stable output
  // for both compact and pretty modes.
  const hasOptionalEmptyAlt = emptyCount === 1 && alts.length >= 2;
  const groupAlts = hasOptionalEmptyAlt
    ? alts.filter((a) => a.text !== "")
    : alts;
  const groupSuffix = hasOptionalEmptyAlt ? "?" : "";

  if (groupAlts.length === 0) {
    return makeEmitted("", false);
  }

  if (groupAlts.length === 1) {
    return makeEmitted(`${open}${groupAlts[0].text})${groupSuffix}`, true);
  }

  const arrangedBlocks = arrangePrettyAltBlocks(
    groupAlts,
    effectiveWrapCol,
    innerCol,
  );
  const arrangedAltTexts = flattenAltBlocksToTexts(arrangedBlocks);

  if (!pretty) {
    return makeEmitted(
      `${open}${arrangedAltTexts.join("|")})${groupSuffix}`,
      true,
    );
  }

  // Pretty-mode inline optimization:
  // Only inline "simple" alternations (all alts single-line and group-free).
  const canInlineSimpleGroup = groupAlts.every(isSimpleInlineAlt);
  if (canInlineSimpleGroup) {
    const inline = `${open}${arrangedAltTexts.join("|")})${groupSuffix}`;
    if (lineCol + inline.length <= effectiveWrapCol) {
      return makeEmitted(inline, true);
    }
  }

  // Multiline group with simple-alt packing.
  const base = " ".repeat(lineCol);
  const inner = autoIndent ? " ".repeat(col) : " ".repeat(lineCol + indentSize);

  /** @type {string[]} */
  const lines = [];
  lines.push(open);
  let hasEmittedAlt = false;

  for (const block of arrangedBlocks) {
    if (block.type === "complex") {
      appendPrettyAltLines(lines, block.alt, !hasEmittedAlt, inner, autoIndent);
      hasEmittedAlt = true;
      continue;
    }

    if (block.tokens.length === 0) continue;

    const packedLines = packSimpleAltTokens(
      block.tokens,
      effectiveWrapCol,
      inner.length,
      !hasEmittedAlt,
    );

    for (const packedLine of packedLines) {
      const prefix = hasEmittedAlt ? `${inner}|` : inner;
      lines.push(prefix + packedLine);
      hasEmittedAlt = true;
    }
  }

  lines.push(base + `)${groupSuffix}`);
  return makeEmitted(lines.join("\n"), true);
}

/**
 * Build regex from literal strings via trie grouping.
 * @param {string[]} strings
 * @param {EmitOptions} opts
 * @returns {string}
 */
export function buildRegexFromStrings(strings, opts = {}) {
  const uniq = uniqueStable(strings);
  const trie = buildTrie(uniq);
  const comp = compressTrie(trie);
  return emitNode(
    comp,
    opts,
    0,
    {
      wordTailLen: 0,
      wordTail: "",
      lastChar: null,
    },
    0, // break column
    0, // line-start column
    0, // wrap shift
  ).text;
}

/* ---------------------------------- CLI ---------------------------------- */

function addCsvWordsToSet(set, raw) {
  if (raw == null) return;
  for (const part of String(raw).split(",")) {
    const w = part.trim();
    if (w) set.add(w);
  }
}

function parseArgs(argv) {
  const args = {
    file: null,
    pretty: true,
    json: false,
    groupStyle: "capturing",
    indent: 'auto',
    wrap: 100,
    minWordSplitLen: 3,
    forbidSplitWords: new Set(),
  };

  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];

    if (!a.startsWith("-") && !args.file) {
      args.file = a;
      continue;
    }

    if (a === "--compact") args.pretty = false;
    else if (a === "--pretty") args.pretty = true;
    else if (a === "--json") args.json = true;
    else if (a === "--capturing") args.groupStyle = "capturing";
    else if (a === "--noncapturing") args.groupStyle = "noncapturing";
    else if (a === "--indent") {
      const raw = argv[++i];
      if (raw == null) {
        throw new Error("Missing value for --indent");
      }

      if (raw === "auto") {
        args.indent = "auto";
      } else {
        const v = Number(raw);
        if (!Number.isFinite(v) || v < 0) {
          throw new Error(`Invalid --indent value: ${raw}`);
        }
        args.indent = v;
      }
    } else if (a === "--help" || a === "-h") {
      printHelpAndExit(0);
    } else if (a === "--wrap") {
      const v = Number(argv[++i]);
      if (!Number.isFinite(v) || v <= 0) {
        throw new Error(`Invalid --wrap value: ${v}`);
      }
      args.wrap = v;
    } else if (a === "--min-word-split") {
      const v = Number(argv[++i]);
      if (!Number.isFinite(v) || v < 0)
        throw new Error(`Invalid --min-word-split value: ${v}`);
      args.minWordSplitLen = v;
    } else if (a === "--no-split" || a.startsWith("--no-split=")) {
      const raw =
        a === "--no-split" ? argv[++i] : a.slice("--no-split=".length);

      if (raw == null) {
        throw new Error("Missing value for --no-split");
      }

      addCsvWordsToSet(args.forbidSplitWords, raw);
    } else {
      throw new Error(`Unknown argument: ${a}`);
    }
  }

  return args;
}

function printHelpAndExit(code = 0) {
  console.log(`
Usage:
  node regex-builder.mjs <input.txt> [options]

Options:
  --pretty                   Pretty multiline output (default)
  --compact                  Single-line compact regex
  --json                     Print compressed trie as JSON instead of regex
  --capturing                Use (...) groups (default)
  --noncapturing             Use (?:...) groups
  --indent N|auto            Pretty-print indentation width, or continuation-column alignment (default: auto)
  --wrap N                   Maximum emitted line length in pretty mode (default: 100)
  --min-word-split N         Minimum chars in current word before mid-word factoring (default: 3)
  --no-split W1[,...W2]      Forbid mid-word splitting before completing these fragments (exact, case-sensitive)
  -h, --help                 Show this help

Input:
  Newline-separated strings. Leading "|" is allowed per line.
`);
  process.exit(code);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (!args.file) printHelpAndExit(1);

  const text = await fs.readFile(args.file, "utf8");
  const strings = parseInputLines(text);

  if (strings.length === 0) {
    throw new Error("No input strings found.");
  }

  const trie = buildTrie(uniqueStable(strings));
  const comp = compressTrie(trie);

  if (args.json) {
    console.log(JSON.stringify(compTrieToObject(comp), null, 2));
    return;
  }

  const rendered = emitNode(
    comp,
    {
      pretty: args.pretty,
      indent: args.indent,
      wrap: args.wrap,
      groupStyle: args.groupStyle,
      minWordSplitLen: args.minWordSplitLen,
      forbidSplitWords: args.forbidSplitWords,
    },
    0,
    { wordTailLen: 0, wordTail: "", lastChar: null },
    0, // break column
    0, // line-start column
    0, // wrap shift
  );

  console.log(rendered.text);
}

const isMain =
  path.resolve(process.argv[1] || "") === fileURLToPath(import.meta.url);
if (isMain) {
  main().catch((err) => {
    console.error(err?.stack || String(err));
    process.exit(1);
  });
}
