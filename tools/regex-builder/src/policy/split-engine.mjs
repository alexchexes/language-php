export const SPLIT_BOUNDARY_KINDS = Object.freeze({
  underscore: "underscore",
  digit: "digit",
  camel: "camel",
  midword: "midword",
});

/**
 * @param {string | null} prevChar
 * @param {string | null} nextChar
 * @returns {"underscore" | "digit" | "camel" | "midword"}
 */
export function classifyBoundary(prevChar, nextChar) {
  if (prevChar === "_" || nextChar === "_") {
    return SPLIT_BOUNDARY_KINDS.underscore;
  }

  if (isDigit(prevChar) || isDigit(nextChar)) {
    return SPLIT_BOUNDARY_KINDS.digit;
  }

  if (isLowercaseAscii(prevChar) && isUppercaseAscii(nextChar)) {
    return SPLIT_BOUNDARY_KINDS.camel;
  }

  return SPLIT_BOUNDARY_KINDS.midword;
}

/**
 * @param {string} value
 * @param {number} splitPos
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {{
 *   allowed: boolean,
 *   reason: "forced" | "no-split" | "boundary" | "midword-threshold" | "midword",
 *   boundaryKind: "underscore" | "digit" | "camel" | "midword"
 * }}
 */
export function evaluateLiteralSplit(value, splitPos, opts) {
  if (splitPos <= 0 || splitPos >= value.length) {
    return {
      allowed: false,
      reason: "midword-threshold",
      boundaryKind: SPLIT_BOUNDARY_KINDS.midword,
    };
  }

  const splitFragment = value.slice(0, splitPos);
  const suffix = value.slice(splitPos);
  const localPrefix = value.slice(value.lastIndexOf("_", splitPos - 1) + 1, splitPos);
  const boundaryKind = classifyBoundary(value[splitPos - 1] ?? null, value[splitPos] ?? null);

  return evaluateSplit({
    splitFragment,
    blacklistSource: splitFragment,
    localPrefixLen: localPrefix.length,
    boundaryKind,
    hasRemainderPath(remainder) {
      return suffix.startsWith(remainder);
    },
  }, opts);
}

/**
 * @param {{
 *   fullTail: string,
 *   wordTail: string,
 *   lastChar: string | null,
 *   localPrefixLen: number
 * }} afterPrefixState
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} childNode
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {{
 *   allowed: boolean,
 *   reasons: Array<{
 *     allowed: boolean,
 *     reason: "forced" | "no-split" | "boundary" | "midword-threshold" | "midword",
 *     boundaryKind: "underscore" | "digit" | "camel" | "midword"
 *   }>
 * }}
 */
export function evaluateTrieSplit(afterPrefixState, childNode, opts) {
  const defs = listDirectAltDefs(childNode);
  const reasons = defs.map((def) => evaluateTrieSplitForDef(afterPrefixState, def, opts));

  return {
    allowed: reasons.every((entry) => entry.allowed),
    reasons,
  };
}

/**
 * @param {{
 *   fullTail: string,
 *   wordTail: string,
 *   lastChar: string | null,
 *   localPrefixLen: number
 * }} afterPrefixState
 * @param {{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }} def
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {{
 *   allowed: boolean,
 *   reason: "forced" | "no-split" | "boundary" | "midword-threshold" | "midword",
 *   boundaryKind: "underscore" | "digit" | "camel" | "midword"
 * }}
 */
export function evaluateTrieSplitForDef(afterPrefixState, def, opts) {
  const nextChar = def.kind === "edge" ? firstLabelChar(def.edge) : null;
  const boundaryKind = classifyBoundary(afterPrefixState.lastChar, nextChar);

  return evaluateSplit({
    splitFragment: afterPrefixState.fullTail,
    blacklistSource: afterPrefixState.fullTail,
    localPrefixLen: afterPrefixState.localPrefixLen,
    boundaryKind,
    hasRemainderPath(remainder) {
      return directDefHasPathPrefix(def, remainder);
    },
  }, opts);
}

/**
 * @param {{ terminal: boolean, edges: Array<{ label: string, node: any }> }} node
 * @returns {Array<{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }>}
 */
export function listDirectAltDefs(node) {
  /** @type {Array<{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }>} */
  const defs = [];

  if (node.terminal) {
    defs.push({ kind: "terminal" });
  }

  for (const edge of node.edges) {
    defs.push({ kind: "edge", edge });
  }

  return defs;
}

/**
 * @param {{
 *   splitFragment: string,
 *   blacklistSource: string,
 *   localPrefixLen: number,
 *   boundaryKind: "underscore" | "digit" | "camel" | "midword",
 *   hasRemainderPath: (remainder: string) => boolean
 * }} context
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {{
 *   allowed: boolean,
 *   reason: "forced" | "no-split" | "boundary" | "midword-threshold" | "midword",
 *   boundaryKind: "underscore" | "digit" | "camel" | "midword"
 * }}
 */
function evaluateSplit(context, opts) {
  const forced = opts.forceSplitWords.has(context.splitFragment);
  const blockingFragment = findBlockingForbiddenFragment(
    context.blacklistSource,
    context.hasRemainderPath,
    opts.forbidSplitWords,
  );

  if (blockingFragment != null && !opts.forceSplitWords.has(blockingFragment)) {
    return { allowed: false, reason: "no-split", boundaryKind: context.boundaryKind };
  }

  if (forced) {
    return { allowed: true, reason: "forced", boundaryKind: context.boundaryKind };
  }

  if (context.boundaryKind !== SPLIT_BOUNDARY_KINDS.midword) {
    return { allowed: true, reason: "boundary", boundaryKind: context.boundaryKind };
  }

  if (opts.minWordSplitLen <= 0 || context.localPrefixLen >= opts.minWordSplitLen) {
    return { allowed: true, reason: "midword", boundaryKind: context.boundaryKind };
  }

  return { allowed: false, reason: "midword-threshold", boundaryKind: context.boundaryKind };
}

/**
 * @param {string} splitFragment
 * @param {(remainder: string) => boolean} hasRemainderPath
 * @param {Set<string>} forbidSet
 * @returns {string | null}
 */
function findBlockingForbiddenFragment(splitFragment, hasRemainderPath, forbidSet) {
  if (forbidSet.size === 0) return null;
  if (splitFragment.length === 0) return null;

  for (const frag of forbidSet) {
    const maxPrefixLen = Math.min(splitFragment.length, frag.length - 1);

    for (let prefixLen = maxPrefixLen; prefixLen >= 1; prefixLen -= 1) {
      const fragPrefix = frag.slice(0, prefixLen);
      if (!splitFragment.endsWith(fragPrefix)) continue;

      const remainder = frag.slice(prefixLen);
      if (remainder.length === 0) continue;
      if (hasRemainderPath(remainder)) return frag;
    }
  }

  return null;
}

/**
 * @param {{ kind: "terminal" } | { kind: "edge", edge: { label: string, node: any } }} def
 * @param {string} wanted
 * @returns {boolean}
 */
function directDefHasPathPrefix(def, wanted) {
  if (wanted.length === 0) return true;
  if (def.kind === "terminal") return false;
  return edgeHasPathPrefix(def.edge, wanted);
}

/**
 * @param {{ label: string, node: any }} edge
 * @param {string} wanted
 * @returns {boolean}
 */
function edgeHasPathPrefix(edge, wanted) {
  const label = edge.label;
  let i = 0;
  const max = Math.min(label.length, wanted.length);

  while (i < max && label[i] === wanted[i]) i += 1;
  if (i === 0) return false;
  if (i === wanted.length) return true;
  if (i < label.length) return false;

  return nodeHasPathPrefix(edge.node, wanted.slice(i));
}

/**
 * @param {{ edges: Array<{ label: string, node: any }> }} node
 * @param {string} wanted
 * @returns {boolean}
 */
function nodeHasPathPrefix(node, wanted) {
  if (wanted.length === 0) return true;

  for (const edge of node.edges) {
    if (edgeHasPathPrefix(edge, wanted)) return true;
  }

  return false;
}

/**
 * @param {{ label: string, node: any }} edge
 * @returns {string | null}
 */
function firstLabelChar(edge) {
  if (edge.label.length > 0) {
    return edge.label[0];
  }

  for (const childEdge of edge.node.edges) {
    const ch = firstLabelChar(childEdge);
    if (ch != null) return ch;
  }

  return null;
}

/**
 * @param {string | null | undefined} ch
 * @returns {boolean}
 */
function isDigit(ch) {
  return ch != null && ch >= "0" && ch <= "9";
}

/**
 * @param {string | null | undefined} ch
 * @returns {boolean}
 */
function isLowercaseAscii(ch) {
  return ch != null && ch >= "a" && ch <= "z";
}

/**
 * @param {string | null | undefined} ch
 * @returns {boolean}
 */
function isUppercaseAscii(ch) {
  return ch != null && ch >= "A" && ch <= "Z";
}
