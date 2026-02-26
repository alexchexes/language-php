/**
 * Direct alt-count of a compressed trie node before rendering.
 * @param {{ terminal: boolean, edges: Array<any> }} node
 * @returns {number}
 */
export function directAltCount(node) {
  return (node.terminal ? 1 : 0) + node.edges.length;
}

/**
 * Whether child has an immediate branch starting with a decimal digit.
 * @param {{ edges: Array<{ label: string }> }} node
 * @returns {boolean}
 */
function hasImmediateDigitBranch(node) {
  return node.edges.some((edge) => /^[0-9]/.test(edge.label));
}

/**
 * Return true if there exists a path from compressed node `node` whose next chars
 * begin with `wanted` (exactly), allowing the match to end in the middle of an edge.
 * @param {{ edges: Array<{ label: string, node: any }> }} node
 * @param {string} wanted
 * @returns {boolean}
 */
function nodeHasPathPrefix(node, wanted) {
  if (wanted.length === 0) return true;

  for (const edge of node.edges) {
    const label = edge.label;
    let i = 0;
    const max = Math.min(label.length, wanted.length);

    while (i < max && label[i] === wanted[i]) i += 1;
    if (i === 0) continue;
    if (i === wanted.length) return true;

    if (i === label.length) {
      if (nodeHasPathPrefix(edge.node, wanted.slice(i))) return true;
    }
  }

  return false;
}

/**
 * @param {{ edges: Array<{ label: string, node: any }> }} childNode
 * @param {{ fullTail: string, wordTail: string, lastChar: string | null }} afterPrefixState
 * @param {{ forbidSplitWords?: Set<string>, forceSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
function isForbiddenMidwordSplitByWordBlacklist(childNode, afterPrefixState, opts) {
  const forbidSet = opts.forbidSplitWords;
  if (!forbidSet || forbidSet.size === 0) return false;

  if (afterPrefixState.lastChar === "_") return false;

  const prefixTail = afterPrefixState.wordTail;
  if (prefixTail.length === 0) return false;

  for (const frag of forbidSet) {
    const maxPrefixLen = Math.min(prefixTail.length, frag.length - 1);

    for (let prefixLen = maxPrefixLen; prefixLen >= 1; prefixLen -= 1) {
      const fragmentPrefix = frag.slice(0, prefixLen);
      if (!prefixTail.endsWith(fragmentPrefix)) continue;

      const remainder = frag.slice(prefixLen);
      if (nodeHasPathPrefix(childNode, remainder)) return true;
    }
  }

  return false;
}

/**
 * @param {{ fullTail: string }} afterPrefixState
 * @param {{ forceSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
function isExplicitlyForcedSplit(afterPrefixState, opts) {
  const forceSet = opts.forceSplitWords;
  if (!forceSet || forceSet.size === 0) return false;
  return forceSet.has(afterPrefixState.fullTail);
}

/**
 * @param {string} splitFragment
 * @param {{ forbidSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
function hasExactNoSplitConflict(splitFragment, opts) {
  const forbidSet = opts.forbidSplitWords;
  if (!forbidSet || forbidSet.size === 0) return false;
  return forbidSet.has(splitFragment);
}

/**
 * @param {{ fullTail: string }} afterPrefixState
 * @param {{ forceSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
export function isForceSplitPoint(afterPrefixState, opts) {
  return isExplicitlyForcedSplit(afterPrefixState, opts);
}

/**
 * Policy: can we factor at this split point (emit PREFIX(group))?
 * @param {{ edges: Array<{ label: string, node: any }> }} childNode
 * @param {{ fullTail: string, wordTail: string, lastChar: string | null, localPrefixLen: number }} afterPrefixState
 * @param {{ minWordSplitLen?: number, forbidSplitWords?: Set<string>, forceSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
export function canFactorAfterPrefix(childNode, afterPrefixState, opts) {
  const minWordSplitLen = opts.minWordSplitLen ?? 3;
  const forced = isExplicitlyForcedSplit(afterPrefixState, opts);

  if (afterPrefixState.lastChar === "_") return true;
  if (hasImmediateDigitBranch(childNode)) return true;

  const blockedByNoSplit = isForbiddenMidwordSplitByWordBlacklist(
    childNode,
    afterPrefixState,
    opts,
  );
  if (
    blockedByNoSplit &&
    !(forced && hasExactNoSplitConflict(afterPrefixState.fullTail, opts))
  ) {
    return false;
  }

  if (forced) return true;
  if (minWordSplitLen <= 0) return true;
  return afterPrefixState.localPrefixLen >= minWordSplitLen;
}
