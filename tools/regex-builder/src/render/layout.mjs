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

