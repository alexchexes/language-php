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
export function arrangePrettyAltBlocks(alts) {
  let blocks = buildPrettyAltBlocks(alts);
  const hasSimpleBlock = blocks.some(
    (block) => block.type === "simple" && block.tokens.length > 0,
  );
  const hasComplexBlock = blocks.some((block) => block.type === "complex");

  if (hasSimpleBlock && hasComplexBlock) {
    blocks = rebalanceSingletonSimpleBlocks(blocks);
  }

  return blocks;
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
 * Move singleton simple blocks into nearby simple blocks.
 * This keeps compact/pretty structural ordering deterministic and
 * independent from wrap/indent settings.
 *
 * @param {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>} blocks
 * @returns {Array<{ type: "complex", alt: any } | { type: "simple", tokens: string[] }>}
 */
function rebalanceSingletonSimpleBlocks(blocks) {
  for (let i = 0; i < blocks.length; i += 1) {
    const block = blocks[i];
    if (block.type !== "simple" || block.tokens.length !== 1) continue;

    const token = block.tokens[0];
    const prevSimpleIndex = findPrevSimpleBlockIndex(blocks, i);
    if (prevSimpleIndex !== -1) {
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
