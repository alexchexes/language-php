/**
 * @typedef {{
 *   fullTail: string,
 *   wordTail: string,
 *   lastChar: string | null,
 *   localPrefixLen: number
 * }} SplitContext
 */

/**
 * @returns {SplitContext}
 */
export function createInitialSplitContext() {
  return {
    fullTail: "",
    wordTail: "",
    lastChar: null,
    localPrefixLen: 0,
  };
}

/**
 * Advance split context through a raw (unescaped) edge label.
 * @param {SplitContext} state
 * @param {string} rawLabel
 * @returns {SplitContext}
 */
export function advanceSplitContext(state, rawLabel) {
  let fullTail = state.fullTail;
  let wordTail = state.wordTail;
  let lastChar = state.lastChar;
  let localPrefixLen = state.localPrefixLen;

  for (const ch of rawLabel) {
    fullTail += ch;
    lastChar = ch;

    if (ch === "_") {
      wordTail = "";
      localPrefixLen = 0;
      continue;
    }

    wordTail += ch;
    localPrefixLen += 1;
  }

  return { fullTail, wordTail, lastChar, localPrefixLen };
}
