/**
 * Direct alt-count of a compressed trie node before rendering.
 * @param {{ terminal: boolean, edges: Array<any> }} node
 * @returns {number}
 */
export function directAltCount(node) {
  return (node.terminal ? 1 : 0) + node.edges.length;
}

/**
 * Whether child has an immediate branch starting with underscore.
 * @param {{ edges: Array<{ label: string }> }} node
 * @returns {boolean}
 */
function hasImmediateUnderscoreBranch(node) {
  return node.edges.some((edge) => edge.label.startsWith("_"));
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
 * Return true if any forbidden fragment has `prefix` as a strict prefix.
 * @param {Set<string> | undefined} forbidSet
 * @param {string} prefix
 * @returns {boolean}
 */
function hasForbiddenFragmentWithStrictPrefix(forbidSet, prefix) {
  if (!forbidSet || forbidSet.size === 0) return false;

  for (const value of forbidSet) {
    if (value.length > prefix.length && value.startsWith(prefix)) return true;
  }

  return false;
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
 * @param {{ wordTail: string, lastChar: string | null }} afterPrefixState
 * @param {{ forbidSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
function isForbiddenMidwordSplitByWordBlacklist(childNode, afterPrefixState, opts) {
  const forbidSet = opts.forbidSplitWords;
  if (!forbidSet || forbidSet.size === 0) return false;

  if (afterPrefixState.lastChar === "_") return false;
  if (hasImmediateUnderscoreBranch(childNode)) return false;

  const prefix = afterPrefixState.wordTail;
  if (!hasForbiddenFragmentWithStrictPrefix(forbidSet, prefix)) return false;

  for (const frag of forbidSet) {
    if (!(frag.length > prefix.length && frag.startsWith(prefix))) continue;
    const remainder = frag.slice(prefix.length);
    if (nodeHasPathPrefix(childNode, remainder)) return true;
  }

  return false;
}

/**
 * Policy: can we factor at this split point (emit PREFIX(group))?
 * @param {{ edges: Array<{ label: string, node: any }> }} childNode
 * @param {{ wordTail: string, lastChar: string | null, localPrefixLen: number }} afterPrefixState
 * @param {{ minWordSplitLen?: number, forbidSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
export function canFactorAfterPrefix(childNode, afterPrefixState, opts) {
  const minWordSplitLen = opts.minWordSplitLen ?? 3;

  if (afterPrefixState.lastChar === "_") return true;
  if (hasImmediateDigitBranch(childNode)) return true;

  if (
    isForbiddenMidwordSplitByWordBlacklist(childNode, afterPrefixState, opts)
  ) {
    return false;
  }

  if (minWordSplitLen <= 0) return true;
  return afterPrefixState.localPrefixLen >= minWordSplitLen;
}
