import { IR_NODE_KINDS } from "../types.mjs";
import {
  altGroupNode,
  concatNode,
  literalNode,
  optionalNode,
} from "../node-utils.mjs";

/**
 * Structural regrouping pass.
 *
 * Prefix example:
 *   SA_UID(NEXT|VALIDITY)|SA_UNSEEN -> SA_(UID(NEXT|VALIDITY)|UNSEEN)
 *
 * Suffix example:
 *   CLOSETIMEOUT|OPENTIMEOUT|READTIMEOUT|WRITETIMEOUT
 *   -> (CLOSE|OPEN|READ|WRITE)TIMEOUT
 *
 * @param {import("../types.mjs").RegexIR} node
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   enableSuffixGrouping?: boolean
 * }} opts
 * @returns {import("../types.mjs").RegexIR}
 */
export function applyPrefixGroupingTransform(node, opts = {}) {
  return visit(node, opts);
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   enableSuffixGrouping?: boolean
 * }} opts
 * @returns {import("../types.mjs").RegexIR}
 */
function visit(node, opts) {
  switch (node.kind) {
    case IR_NODE_KINDS.literal:
      return node;

    case IR_NODE_KINDS.concat:
      return concatNode(node.parts.map((part) => visit(part, opts)));

    case IR_NODE_KINDS.optional:
      return optionalNode(visit(node.child, opts));

    case IR_NODE_KINDS.altGroup: {
      const visitedAlts = node.alternatives.map((alt) => visit(alt, opts));
      const byPrefix = regroupByUnderscorePrefix(visitedAlts, opts);
      const withSuffixGrouping =
        opts.enableSuffixGrouping === false
          ? byPrefix
          : regroupBySuffix(byPrefix, opts);
      return altGroupNode(withSuffixGrouping, { force: true });
    }

    default:
      return node;
  }
}

/**
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR[]}
 */
function regroupByUnderscorePrefix(alternatives, opts) {
  const meta = alternatives.map((alt, index) => ({
    index,
    alt,
    leadingLiteral: getLeadingLiteral(alt),
  }));

  const prefixes = collectCandidatePrefixes(meta);
  if (prefixes.length === 0) return alternatives;

  const used = new Set();
  const groupsByStartIndex = new Map();

  for (const prefix of prefixes) {
    const members = meta.filter(
      (entry) =>
        !used.has(entry.index) &&
        typeof entry.leadingLiteral === "string" &&
        entry.leadingLiteral.startsWith(prefix),
    );
    if (members.length < 2) continue;
    if (!canGroupAtPrefix(prefix, members, opts)) continue;

    const memberIndexes = members
      .map((entry) => entry.index)
      .sort((a, b) => a - b);

    for (const idx of memberIndexes) used.add(idx);
    const startIndex = memberIndexes[0];
    if (groupsByStartIndex.has(startIndex)) continue;

    groupsByStartIndex.set(startIndex, { prefix, memberIndexes });
  }

  if (groupsByStartIndex.size === 0) return alternatives;

  const out = [];
  for (let i = 0; i < alternatives.length; i += 1) {
    const group = groupsByStartIndex.get(i);
    if (group) {
      const groupedSuffixes = group.memberIndexes.map((idx) =>
        removePrefixFromLeadingLiteral(alternatives[idx], group.prefix),
      );

      out.push(
        concatNode([
          literalNode(group.prefix),
          altGroupNode(groupedSuffixes, { force: true }),
        ]),
      );
      continue;
    }

    if (used.has(i)) continue;
    out.push(alternatives[i]);
  }

  return out;
}

/**
 * Prefix regroup policy.
 *
 * - Prefixes ending with "_" are always allowed (underscore boundary).
 * - For mixed underscore-boundary prefixes (e.g. U_ + ULOC_ => U):
 *   every non-special suffix branch must satisfy reverse min-split and --no-split.
 *
 * @param {string} prefix
 * @param {Array<{ leadingLiteral: string | null }>} members
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>
 * }} opts
 * @returns {boolean}
 */
function canGroupAtPrefix(prefix, members, opts) {
  if (prefix.endsWith("_")) return true;

  let hasUnderscoreMember = false;
  let hasNonUnderscoreMember = false;

  for (const member of members) {
    if (typeof member.leadingLiteral !== "string") return false;

    const value = member.leadingLiteral;
    const splitPos = prefix.length;
    if (splitPos > value.length) return false;
    const suffix = value.slice(splitPos);

    if (suffix.length === 0) continue;
    if (suffix.startsWith("_")) {
      hasUnderscoreMember = true;
      continue;
    }

    hasNonUnderscoreMember = true;
    if (/^[0-9]/.test(suffix)) continue;

    if (isForbiddenMidwordSplitByWordBlacklist(value, splitPos, opts)) {
      return false;
    }

    const nextBoundary = suffix.indexOf("_");
    if (nextBoundary === -1) return false;

    const minWordSplitLen = opts.minWordSplitLen ?? 3;
    if (minWordSplitLen > 0) {
      const localSuffixLen = nextBoundary;
      if (localSuffixLen < minWordSplitLen) return false;
    }
  }

  return hasUnderscoreMember && hasNonUnderscoreMember;
}

/**
 * Reverse-order grouping by common suffix for plain literal alternatives.
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR[]}
 */
function regroupBySuffix(alternatives, opts) {
  const minMembers = 3;
  const meta = alternatives.map((alt, index) => ({
    index,
    alt,
    value: getWholeLiteralValue(alt),
  }));

  const candidateMap = new Map();
  for (const entry of meta) {
    if (entry.value == null) continue;

    for (let splitPos = 1; splitPos < entry.value.length; splitPos += 1) {
      if (!isReverseSplitAllowed(entry.value, splitPos, opts)) continue;
      const suffix = entry.value.slice(splitPos);
      const prefix = entry.value.slice(0, splitPos);
      if (prefix.length === 0 || suffix.length === 0) continue;

      const arr = candidateMap.get(suffix) ?? [];
      arr.push({ index: entry.index, splitPos });
      candidateMap.set(suffix, arr);
    }
  }

  const suffixes = [...candidateMap.keys()]
    .filter((suffix) => {
      const uniqueCount = new Set(candidateMap.get(suffix).map((m) => m.index))
        .size;
      return uniqueCount >= minMembers;
    })
    .sort((a, b) => {
      const aCount = new Set(candidateMap.get(a).map((m) => m.index)).size;
      const bCount = new Set(candidateMap.get(b).map((m) => m.index)).size;
      return bCount - aCount || b.length - a.length || a.localeCompare(b);
    });

  if (suffixes.length === 0) return alternatives;

  const used = new Set();
  const groupsByStartIndex = new Map();

  for (const suffix of suffixes) {
    const rawMembers = candidateMap.get(suffix) ?? [];
    const members = rawMembers.filter((m) => !used.has(m.index));
    const uniqueIndexes = [...new Set(members.map((m) => m.index))].sort(
      (a, b) => a - b,
    );
    if (uniqueIndexes.length < minMembers) continue;

    // This transform only regroups plain literal alts.
    const memberDefs = uniqueIndexes.map((idx) =>
      members.find((m) => m.index === idx),
    );
    if (memberDefs.some((m) => !m)) continue;

    for (const idx of uniqueIndexes) used.add(idx);
    const startIndex = uniqueIndexes[0];
    if (groupsByStartIndex.has(startIndex)) continue;

    groupsByStartIndex.set(startIndex, {
      suffix,
      members: memberDefs,
    });
  }

  if (groupsByStartIndex.size === 0) return alternatives;

  const out = [];
  for (let i = 0; i < alternatives.length; i += 1) {
    const group = groupsByStartIndex.get(i);
    if (group) {
      const groupedPrefixes = group.members.map((member) => {
        const value = /** @type {string} */ (meta[member.index].value);
        return literalNode(value.slice(0, member.splitPos));
      });

      out.push(
        concatNode([
          altGroupNode(groupedPrefixes, { force: true }),
          literalNode(group.suffix),
        ]),
      );
      continue;
    }

    if (used.has(i)) continue;
    out.push(alternatives[i]);
  }

  return out;
}

/**
 * Split policy for reverse-order (suffix) grouping.
 *
 * We apply the same core constraints, but at the split before the suffix:
 * - allow underscore boundary (suffix starts with "_")
 * - allow digit boundary (suffix starts with digit)
 * - obey --no-split
 * - enforce --min-word-split against the suffix-side local segment
 *
 * @param {string} value
 * @param {number} splitPos
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>
 * }} opts
 * @returns {boolean}
 */
function isReverseSplitAllowed(value, splitPos, opts) {
  const minWordSplitLen = opts.minWordSplitLen ?? 3;
  const suffix = value.slice(splitPos);
  if (suffix.length === 0) return false;

  if (suffix.startsWith("_")) return true;
  if (/^[0-9]/.test(suffix)) return true;

  if (isForbiddenMidwordSplitByWordBlacklist(value, splitPos, opts)) {
    return false;
  }

  if (minWordSplitLen <= 0) return true;

  // Reverse-order local segment length: chars from split point to next "_".
  const localSuffixLen = suffix.split("_", 1)[0].length;
  return localSuffixLen >= minWordSplitLen;
}

/**
 * Mid-word split blacklist check at literal split point.
 * @param {string} value
 * @param {number} splitPos
 * @param {{ forbidSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
function isForbiddenMidwordSplitByWordBlacklist(value, splitPos, opts) {
  const forbidSet = opts.forbidSplitWords;
  if (!forbidSet || forbidSet.size === 0) return false;

  const suffix = value.slice(splitPos);
  if (suffix.startsWith("_")) return false;

  const lastUnderscore = value.lastIndexOf("_", splitPos - 1);
  const prefixTail = value.slice(lastUnderscore + 1, splitPos);
  if (prefixTail.length === 0) return false;

  if (!hasForbiddenFragmentWithStrictPrefix(forbidSet, prefixTail)) return false;

  for (const frag of forbidSet) {
    if (!(frag.length > prefixTail.length && frag.startsWith(prefixTail))) continue;
    const remainder = frag.slice(prefixTail.length);
    if (suffix.startsWith(remainder)) return true;
  }

  return false;
}

/**
 * @param {Set<string> | undefined} forbidSet
 * @param {string} prefix
 * @returns {boolean}
 */
function hasForbiddenFragmentWithStrictPrefix(forbidSet, prefix) {
  if (!forbidSet || forbidSet.size === 0) return false;

  for (const word of forbidSet) {
    if (word.length > prefix.length && word.startsWith(prefix)) return true;
  }

  return false;
}

/**
 * @param {Array<{ leadingLiteral: string | null }>} meta
 * @returns {string[]}
 */
function collectCandidatePrefixes(meta) {
  const set = new Set();

  for (const entry of meta) {
    if (typeof entry.leadingLiteral !== "string") continue;
    for (const prefix of underscorePrefixes(entry.leadingLiteral)) {
      set.add(prefix);
    }
  }

  for (let i = 0; i < meta.length; i += 1) {
    const a = meta[i].leadingLiteral;
    if (typeof a !== "string") continue;

    for (let j = i + 1; j < meta.length; j += 1) {
      const b = meta[j].leadingLiteral;
      if (typeof b !== "string") continue;

      const prefix = mixedBoundaryPrefix(a, b);
      if (prefix) set.add(prefix);
    }
  }

  return [...set].sort((a, b) => b.length - a.length || a.localeCompare(b));
}

/**
 * Return a common prefix candidate when one branch continues with "_" and another
 * continues with a non-underscore character (e.g. U_ vs ULOC_ -> U).
 * @param {string} a
 * @param {string} b
 * @returns {string | null}
 */
function mixedBoundaryPrefix(a, b) {
  const max = Math.min(a.length, b.length);
  let i = 0;

  while (i < max && a[i] === b[i]) i += 1;
  if (i <= 0) return null;

  const nextA = a[i] ?? null;
  const nextB = b[i] ?? null;
  if (nextA !== "_" && nextB !== "_") return null;

  return a.slice(0, i);
}

/**
 * @param {string} value
 * @returns {string[]}
 */
function underscorePrefixes(value) {
  const out = [];

  for (let i = 0; i < value.length; i += 1) {
    if (value[i] !== "_") continue;
    out.push(value.slice(0, i + 1));
  }

  return out;
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @returns {string | null}
 */
function getLeadingLiteral(node) {
  if (node.kind === IR_NODE_KINDS.literal) return node.value;

  if (node.kind === IR_NODE_KINDS.concat) {
    let value = "";

    for (const part of node.parts) {
      if (part.kind !== IR_NODE_KINDS.literal) break;
      value += part.value;
    }

    return value.length > 0 ? value : null;
  }

  return null;
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @returns {string | null}
 */
function getWholeLiteralValue(node) {
  if (node.kind === IR_NODE_KINDS.literal) return node.value;
  return null;
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @param {string} prefix
 * @returns {import("../types.mjs").RegexIR}
 */
function removePrefixFromLeadingLiteral(node, prefix) {
  if (node.kind === IR_NODE_KINDS.literal) {
    return literalNode(node.value.slice(prefix.length));
  }

  if (node.kind === IR_NODE_KINDS.concat) {
    if (prefix.length === 0) return node;

    let remaining = prefix.length;
    let index = 0;
    /** @type {import("../types.mjs").RegexIR[]} */
    const outParts = [];

    while (index < node.parts.length && remaining > 0) {
      const part = node.parts[index];
      if (part.kind !== IR_NODE_KINDS.literal) return node;

      if (part.value.length <= remaining) {
        remaining -= part.value.length;
        index += 1;
        continue;
      }

      outParts.push(literalNode(part.value.slice(remaining)));
      remaining = 0;
      index += 1;
      break;
    }

    if (remaining > 0) return node;
    outParts.push(...node.parts.slice(index));
    return concatNode(outParts);
  }

  return node;
}
