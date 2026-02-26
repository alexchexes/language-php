/**
 * @param {{ singleLine: boolean, hasGroup: boolean }} alt
 * @returns {boolean}
 */
export function isSimpleInlineAlt(alt) {
  return alt.singleLine && !alt.hasGroup;
}

/**
 * @param {Array<{ text: string, singleLine: boolean, hasGroup: boolean }>} alts
 * @returns {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>}
 */
function buildPrettyAltBlocks(alts) {
  /** @type {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} */
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
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} blockIndex
 * @returns {boolean}
 */
function isFirstOutputBlock(blocks, blockIndex) {
  for (let i = 0; i < blockIndex; i += 1) {
    const block = blocks[i];
    if (block.type === "complex") return false;
    if (block.type === "simple" && block.tokens.length > 0) return false;
  }

  return true;
}

/**
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} index
 * @returns {number}
 */
function findPrevSimpleBlockIndex(blocks, index) {
  for (let i = index - 1; i >= 0; i -= 1) {
    const block = blocks[i];
    if (block.type === "simple" && block.tokens.length > 0) return i;
  }

  return -1;
}

/**
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} index
 * @returns {number}
 */
function findNextSimpleBlockIndex(blocks, index) {
  for (let i = index + 1; i < blocks.length; i += 1) {
    const block = blocks[i];
    if (block.type === "simple" && block.tokens.length > 0) return i;
  }

  return -1;
}

/**
 * Pack simple alternatives into wrapped line payloads (without indentation/prefix).
 * @param {string[]} tokens
 * @param {number} wrapCol
 * @param {number} innerCol
 * @param {boolean} firstLineHasNoPipe
 * @returns {string[]}
 */
export function packSimpleAltTokens(tokens, wrapCol, innerCol, firstLineHasNoPipe) {
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
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} blockIndex
 * @param {string} token
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {boolean}
 */
function canAppendTokenToSimpleBlock(blocks, blockIndex, token, wrapCol, innerCol) {
  const block = blocks[blockIndex];
  if (!block || block.type !== "simple" || block.tokens.length === 0) return false;

  const firstLineHasNoPipe = isFirstOutputBlock(blocks, blockIndex);
  const layoutInnerCol = Math.max(innerCol, 12);
  const packed = packSimpleAltTokens(
    block.tokens,
    wrapCol,
    layoutInnerCol,
    firstLineHasNoPipe,
  );
  if (packed.length === 0) return false;

  const lastLine = packed[packed.length - 1];
  const lastPrefixLen =
    layoutInnerCol + (firstLineHasNoPipe && packed.length === 1 ? 0 : 1);

  return lastPrefixLen + lastLine.length + 1 + token.length <= wrapCol;
}

/**
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} blockIndex
 * @param {string} token
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {boolean}
 */
function canPrependTokenToSimpleBlock(blocks, blockIndex, token, wrapCol, innerCol) {
  const block = blocks[blockIndex];
  if (!block || block.type !== "simple" || block.tokens.length === 0) return false;

  const firstLineHasNoPipe = isFirstOutputBlock(blocks, blockIndex);
  const layoutInnerCol = Math.max(innerCol, 12);
  const packed = packSimpleAltTokens(
    [token, ...block.tokens],
    wrapCol,
    layoutInnerCol,
    firstLineHasNoPipe,
  );
  if (packed.length === 0) return false;
  return packed[0].includes("|");
}

/**
 * Move singleton simple blocks into nearby simple blocks to avoid isolated leftovers.
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>}
 */
function rebalanceSingletonSimpleBlocks(blocks, wrapCol, innerCol) {
  for (let i = 0; i < blocks.length; i += 1) {
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
 * Move singleton wrapped lines from mixed simple blocks into nearby simple blocks.
 *
 * Example:
 *   A|B|C  (wrap)  D  + complex + E|F
 * becomes:
 *   A|B|C  + complex + D|E|F
 *
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>}
 */
function rebalanceWrappedSingletonSimpleLines(blocks, wrapCol, innerCol) {
  for (let i = 0; i < blocks.length; i += 1) {
    const block = blocks[i];
    if (block.type !== "simple" || block.tokens.length < 2) continue;

    const firstLineHasNoPipe = isFirstOutputBlock(blocks, i);
    const layoutInnerCol = Math.max(innerCol, 12);
    const packed = packSimpleAltTokens(
      block.tokens,
      wrapCol,
      layoutInnerCol,
      firstLineHasNoPipe,
    );
    if (packed.length < 2) continue;

    const lastLine = packed[packed.length - 1];
    if (!lastLine.includes("|")) {
      const token = block.tokens[block.tokens.length - 1];
      const nextSimpleIndex = findNextSimpleBlockIndex(blocks, i);
      const nextSimpleBlock =
        nextSimpleIndex === -1 ? null : blocks[nextSimpleIndex];

      if (
        nextSimpleIndex !== -1 &&
        nextSimpleBlock &&
        nextSimpleBlock.type === "simple" &&
        nextSimpleBlock.tokens.length > 0 &&
        nextSimpleBlock.tokens.length <= 2 &&
        canPrependTokenToSimpleBlock(
          blocks,
          nextSimpleIndex,
          token,
          wrapCol,
          innerCol,
        )
      ) {
        block.tokens.pop();
        blocks[nextSimpleIndex].tokens.unshift(token);
      }
    }

    const refreshedPacked = packSimpleAltTokens(
      block.tokens,
      wrapCol,
      layoutInnerCol,
      firstLineHasNoPipe,
    );
    if (refreshedPacked.length < 2) continue;

    const firstLine = refreshedPacked[0];
    if (!firstLine.includes("|")) {
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
        block.tokens.shift();
        blocks[prevSimpleIndex].tokens.push(token);
      }
    }
  }

  return blocks;
}

/**
 * @param {Array<{ text: string, singleLine: boolean, hasGroup: boolean }>} alts
 * @param {number} wrapCol
 * @param {number} innerCol
 * @returns {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>}
 */
export function arrangePrettyAltBlocks(alts, wrapCol, innerCol) {
  let blocks = buildPrettyAltBlocks(alts);
  const hasSimpleBlock = blocks.some(
    (block) => block.type === "simple" && block.tokens.length > 0,
  );
  const hasComplexBlock = blocks.some((block) => block.type === "complex");

  if (hasSimpleBlock && hasComplexBlock) {
    blocks = rebalanceSingletonSimpleBlocks(blocks, wrapCol, innerCol);
    blocks = rebalanceWrappedSingletonSimpleLines(blocks, wrapCol, innerCol);
    blocks = rebalanceSingletonSimpleBlocks(blocks, wrapCol, innerCol);
  }

  return blocks;
}

/**
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @returns {string[]}
 */
export function flattenAltBlocksToTexts(blocks) {
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
