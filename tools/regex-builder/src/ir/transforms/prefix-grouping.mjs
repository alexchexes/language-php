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
 *   forceSplitWords?: Set<string>,
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
 *   forceSplitWords?: Set<string>,
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
      const withBridgeOptional = collapseBoundaryBridgeAlternatives(
        withSuffixGrouping,
      );
      const withForcedNested = regroupByForcedNestedPrefix(
        withBridgeOptional,
        opts,
      );
      return altGroupNode(withForcedNested, { force: true });
    }

    default:
      return node;
  }
}

/**
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
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
    if (!canGroupAtPrefix(prefix)) continue;

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
 * Only prefixes ending with "_" are allowed (underscore boundary).
 *
 * @param {string} prefix
 * @returns {boolean}
 */
function canGroupAtPrefix(prefix) {
  return prefix.endsWith("_");
}

/**
 * Reverse-order grouping by common suffix for plain literal alternatives.
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR[]}
 */
function regroupBySuffix(alternatives, opts) {
  const meta = alternatives.map((alt, index) => ({
    index,
    alt,
    value: getWholeLiteralValue(alt),
  }));
  const literalValues = new Set(meta.map((entry) => entry.value).filter(Boolean));

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

  const candidateProfiles = new Map();
  for (const [suffix, members] of candidateMap.entries()) {
    candidateProfiles.set(
      suffix,
      buildSuffixCandidateProfile(suffix, members, meta, literalValues),
    );
  }

  const suffixes = [...candidateMap.keys()]
    .filter((suffix) => {
      const uniqueCount = new Set(candidateMap.get(suffix).map((m) => m.index))
        .size;
      const minMembers = candidateProfiles.get(suffix)?.minMembers ?? 3;
      return uniqueCount >= minMembers;
    })
    .sort((a, b) => {
      const aPriority = candidateProfiles.get(a)?.priority ?? 0;
      const bPriority = candidateProfiles.get(b)?.priority ?? 0;
      if (bPriority !== aPriority) return bPriority - aPriority;

      const aCount = new Set(candidateMap.get(a).map((m) => m.index)).size;
      const bCount = new Set(candidateMap.get(b).map((m) => m.index)).size;
      return bCount - aCount || b.length - a.length || a.localeCompare(b);
    });

  if (suffixes.length === 0) return alternatives;

  const used = new Set();
  const groupsByStartIndex = new Map();

  for (const suffix of suffixes) {
    const minMembers = candidateProfiles.get(suffix)?.minMembers ?? 3;
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
 * @param {string} suffix
 * @param {Array<{ index: number, splitPos: number }>} members
 * @param {Array<{ value: string | null }>} meta
 * @param {Set<string>} literalValues
 * @returns {{ minMembers: number, priority: number }}
 */
function buildSuffixCandidateProfile(suffix, members, meta, literalValues) {
  if (isBoundaryBridgeSuffix(suffix, literalValues)) {
    return { minMembers: 2, priority: 2 };
  }

  if (isCleanUnderscoreSuffixPairing(suffix, members, meta)) {
    return { minMembers: 2, priority: 1 };
  }

  return { minMembers: 3, priority: 0 };
}

/**
 * Allow 2-member underscore-suffix grouping when all grouped prefixes are
 * clean single-token fragments (no underscore in the grouped prefix).
 *
 * Examples:
 *   ACTUAL_LOCALE|VALID_LOCALE -> (ACTUAL|VALID)_LOCALE
 *   MAJOR_VERSION|MINOR_VERSION -> (MAJOR|MINOR)_VERSION
 *
 * @param {string} suffix
 * @param {Array<{ index: number, splitPos: number }>} members
 * @param {Array<{ value: string | null }>} meta
 * @returns {boolean}
 */
function isCleanUnderscoreSuffixPairing(suffix, members, meta) {
  if (!suffix.startsWith("_")) return false;

  const byIndex = new Map();
  for (const member of members) {
    if (!byIndex.has(member.index)) {
      byIndex.set(member.index, member);
    }
  }

  if (byIndex.size < 2) return false;

  for (const member of byIndex.values()) {
    const value = meta[member.index]?.value;
    if (value == null) return false;

    const prefix = value.slice(0, member.splitPos);
    if (prefix.length === 0) return false;
    if (prefix.includes("_")) return false;
  }

  return true;
}

/**
 * Collapse bridge-shaped pairs without repeating the base suffix:
 *   ((A|B)_SUFFIX|SUFFIX) -> (((A|B)_)?SUFFIX)
 *
 * This runs after suffix regrouping and keeps structure-only behavior.
 *
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @returns {import("../types.mjs").RegexIR[]}
 */
function collapseBoundaryBridgeAlternatives(alternatives) {
  const baseIndexesByValue = new Map();

  for (let i = 0; i < alternatives.length; i += 1) {
    const lit = getWholeLiteralValue(alternatives[i]);
    if (lit == null) continue;

    const arr = baseIndexesByValue.get(lit) ?? [];
    arr.push(i);
    baseIndexesByValue.set(lit, arr);
  }

  /** @type {Set<number>} */
  const used = new Set();
  /** @type {Map<number, import("../types.mjs").RegexIR>} */
  const mergedByStart = new Map();

  for (let i = 0; i < alternatives.length; i += 1) {
    if (used.has(i)) continue;

    const candidate = splitBridgeSuffixAlternative(alternatives[i]);
    if (!candidate) continue;

    const baseIndexes = baseIndexesByValue.get(candidate.base) ?? [];
    const baseIndex = baseIndexes.find((idx) => idx !== i && !used.has(idx));
    if (baseIndex == null) continue;

    const withBoundary = concatNode([
      candidate.prefixExpr,
      literalNode("_"),
    ]);
    const merged = concatNode([
      optionalNode(withBoundary),
      literalNode(candidate.base),
    ]);

    const start = Math.min(i, baseIndex);
    used.add(i);
    used.add(baseIndex);
    mergedByStart.set(start, merged);
  }

  if (mergedByStart.size === 0) return alternatives;

  const out = [];
  for (let i = 0; i < alternatives.length; i += 1) {
    const merged = mergedByStart.get(i);
    if (merged) {
      out.push(merged);
      continue;
    }

    if (used.has(i)) continue;
    out.push(alternatives[i]);
  }

  return out;
}

/**
 * @param {import("../types.mjs").RegexIR} alt
 * @returns {{ prefixExpr: import("../types.mjs").RegexIR, base: string } | null}
 */
function splitBridgeSuffixAlternative(alt) {
  if (alt.kind !== IR_NODE_KINDS.concat || alt.parts.length < 2) return null;

  const last = alt.parts[alt.parts.length - 1];
  if (last.kind !== IR_NODE_KINDS.literal) return null;
  if (!last.value.startsWith("_")) return null;

  const base = last.value.slice(1);
  if (base.length === 0) return null;

  const prefixParts = alt.parts.slice(0, -1);
  const prefixExpr = concatNode(prefixParts);
  if (prefixExpr.kind === IR_NODE_KINDS.literal && prefixExpr.value === "") {
    return null;
  }

  return { prefixExpr, base };
}

/**
 * Extract a nested forced split into a sibling alternative.
 *
 * Example (with force split on NOT and no-split on TTY):
 *   NO(...|T(BLK|...|TY|...)) -> NO(...|TTY)|NOT(BLK|...|...)
 *
 * @param {import("../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR[]}
 */
function regroupByForcedNestedPrefix(alternatives, opts) {
  const out = [];

  for (const alt of alternatives) {
    const extracted = tryExtractForcedNestedPrefix(alt, opts);
    if (!extracted) {
      out.push(alt);
      continue;
    }

    out.push(extracted.parent);
    out.push(extracted.sibling);
  }

  return out;
}

/**
 * @param {import("../types.mjs").RegexIR} alt
 * @param {{ forbidSplitWords?: Set<string>, forceSplitWords?: Set<string> }} opts
 * @returns {{ parent: import("../types.mjs").RegexIR, sibling: import("../types.mjs").RegexIR } | null}
 */
function tryExtractForcedNestedPrefix(alt, opts) {
  const outer = splitGroupedConcat(alt);
  if (!outer) return null;

  const outerPrefix = outer.prefix;
  const outerAlts = outer.group.alternatives;

  for (let i = 0; i < outerAlts.length; i += 1) {
    const member = outerAlts[i];
    const nested = splitGroupedConcat(member);
    if (!nested) continue;

    const nestedPrefix = nested.prefix;
    if (nestedPrefix.length !== 1) continue;
    if (!hasForcedSuffix(opts.forceSplitWords, `${outerPrefix}${nestedPrefix}`)) {
      continue;
    }

    const nestedAlts = nested.group.alternatives;
    const keepInParent = [];
    const moveToSibling = [];

    for (const nestedAlt of nestedAlts) {
      const lit = getWholeLiteralValue(nestedAlt);
      if (
        lit != null &&
        opts.forbidSplitWords?.has(`${nestedPrefix}${lit}`)
      ) {
        keepInParent.push(literalNode(`${nestedPrefix}${lit}`));
      } else {
        moveToSibling.push(nestedAlt);
      }
    }

    if (moveToSibling.length === 0) continue;

    const parentAlts = [];
    for (let j = 0; j < outerAlts.length; j += 1) {
      if (j !== i) parentAlts.push(outerAlts[j]);
    }
    parentAlts.push(...keepInParent);

    const parent = concatNode([
      literalNode(outerPrefix),
      altGroupNode(parentAlts, { force: true }),
    ]);
    const sibling = concatNode([
      literalNode(`${outerPrefix}${nestedPrefix}`),
      altGroupNode(moveToSibling, { force: true }),
    ]);

    return { parent, sibling };
  }

  // Also support already-flattened literals:
  //   NO(...|TBLK|TCONN|...|TTY|TUNIQ) -> NO(...|TTY)|NOT(BLK|CONN|...|UNIQ)
  for (const nestedPrefix of collectForcedNestedPrefixes(outerAlts, outerPrefix, opts)) {
    const parentAlts = [];
    const moveToSibling = [];

    for (const candidate of outerAlts) {
      const lit = getWholeLiteralValue(candidate);
      if (
        lit != null &&
        lit.startsWith(nestedPrefix) &&
        lit.length > nestedPrefix.length
      ) {
        if (opts.forbidSplitWords?.has(lit)) {
          parentAlts.push(candidate);
        } else {
          moveToSibling.push(literalNode(lit.slice(nestedPrefix.length)));
        }
      } else {
        parentAlts.push(candidate);
      }
    }

    if (moveToSibling.length < 2) continue;

    const parent = concatNode([
      literalNode(outerPrefix),
      altGroupNode(parentAlts, { force: true }),
    ]);
    const sibling = concatNode([
      literalNode(`${outerPrefix}${nestedPrefix}`),
      altGroupNode(moveToSibling, { force: true }),
    ]);

    return { parent, sibling };
  }

  return null;
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @returns {{ prefix: string, group: import("../types.mjs").AltGroupNode } | null}
 */
function splitGroupedConcat(node) {
  if (node.kind !== IR_NODE_KINDS.concat || node.parts.length < 2) return null;

  const last = node.parts[node.parts.length - 1];
  if (last.kind !== IR_NODE_KINDS.altGroup) return null;

  let prefix = "";
  for (let i = 0; i < node.parts.length - 1; i += 1) {
    const part = node.parts[i];
    if (part.kind !== IR_NODE_KINDS.literal) return null;
    prefix += part.value;
  }
  if (prefix.length === 0) return null;

  return { prefix, group: last };
}

/**
 * @param {import("../types.mjs").RegexIR[]} outerAlts
 * @param {string} outerPrefix
 * @param {{ forceSplitWords?: Set<string> }} opts
 * @returns {string[]}
 */
function collectForcedNestedPrefixes(outerAlts, outerPrefix, opts) {
  const set = new Set();

  for (const alt of outerAlts) {
    const lit = getWholeLiteralValue(alt);
    if (lit == null || lit.length < 2) continue;

    const nestedPrefix = lit[0];
    if (!hasForcedSuffix(opts.forceSplitWords, `${outerPrefix}${nestedPrefix}`)) {
      continue;
    }
    set.add(nestedPrefix);
  }

  return [...set].sort();
}

/**
 * @param {Set<string> | undefined} forceSet
 * @param {string} suffix
 * @returns {boolean}
 */
function hasForcedSuffix(forceSet, suffix) {
  if (!forceSet || forceSet.size === 0) return false;
  for (const word of forceSet) {
    if (word.endsWith(suffix)) return true;
  }
  return false;
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
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
 * }} opts
 * @returns {boolean}
 */
function isReverseSplitAllowed(value, splitPos, opts) {
  const minWordSplitLen = opts.minWordSplitLen ?? 3;
  const splitFragment = value.slice(0, splitPos);
  const forced = isForcedReverseSplit(value, splitPos, opts);
  const suffix = value.slice(splitPos);
  if (suffix.length === 0) return false;

  const blockedByNoSplit = isForbiddenMidwordSplitByWordBlacklist(
    value,
    splitPos,
    opts,
  );
  if (
    blockedByNoSplit &&
    !(forced && hasExactNoSplitConflict(splitFragment, opts))
  ) {
    return false;
  }

  if (forced) return true;
  if (suffix.startsWith("_")) return true;
  if (/^[0-9]/.test(suffix)) return true;

  if (minWordSplitLen <= 0) return true;

  // Reverse-order min-word-split uses suffix-side local segment length.
  const localSuffixLen = suffix.split("_", 1)[0].length;
  return localSuffixLen >= minWordSplitLen;
}

/**
 * Boundary-bridge grouping: allow 2-member "_" suffix groups when the
 * non-underscore base literal is also present in the same alternatives.
 *
 * Example:
 *   MAJOR_VERSION|MINOR_VERSION|VERSION -> (MAJOR|MINOR)_VERSION|VERSION
 *
 * This has highest grouping priority and composes with optional collapse:
 *   ((A|B)_SUFFIX|SUFFIX) -> ((A|B)_)?SUFFIX
 * @param {string} suffix
 * @param {Set<string>} literalValues
 * @returns {boolean}
 */
function isBoundaryBridgeSuffix(suffix, literalValues) {
  if (!suffix.startsWith("_")) return false;
  const base = suffix.slice(1);
  if (base.length === 0) return false;
  return literalValues.has(base);
}

/**
 * @param {string} value
 * @param {number} splitPos
 * @param {{ forceSplitWords?: Set<string> }} opts
 * @returns {boolean}
 */
function isForcedReverseSplit(value, splitPos, opts) {
  const forceSet = opts.forceSplitWords;
  if (!forceSet || forceSet.size === 0) return false;
  return forceSet.has(value.slice(0, splitPos));
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

  for (const frag of forbidSet) {
    const maxPrefixLen = Math.min(prefixTail.length, frag.length - 1);

    for (let prefixLen = maxPrefixLen; prefixLen >= 1; prefixLen -= 1) {
      const fragmentPrefix = frag.slice(0, prefixLen);
      if (!prefixTail.endsWith(fragmentPrefix)) continue;

      const remainder = frag.slice(prefixLen);
      if (suffix.startsWith(remainder)) return true;
    }
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

  return [...set].sort((a, b) => b.length - a.length || a.localeCompare(b));
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
  if (node.kind !== IR_NODE_KINDS.concat) return null;

  let value = "";
  for (const part of node.parts) {
    if (part.kind !== IR_NODE_KINDS.literal) return null;
    value += part.value;
  }

  return value;
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
