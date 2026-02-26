import { IR_NODE_KINDS } from "../types.mjs";
import {
  altGroupNode,
  concatNode,
  literalNode,
  optionalNode,
} from "../node-utils.mjs";
import {
  evaluateLiteralSplit,
  SPLIT_BOUNDARY_KINDS,
} from "../../policy/split-engine.mjs";

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
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR}
 */
export function applyPrefixGroupingTransform(node, opts) {
  return visit(node, opts);
}

/**
 * @param {import("../types.mjs").RegexIR} node
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
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
      const withSuffixGrouping = regroupBySuffix(byPrefix, opts);
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
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
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
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {import("../types.mjs").RegexIR[]}
 */
function regroupBySuffix(alternatives, opts) {
  const meta = alternatives.map((alt, index) => ({
    index,
    alt,
    value: getWholeLiteralValue(alt),
  }));
  const literalValues = new Set(
    meta.map((entry) => entry.value).filter((value) => value != null),
  );
  const candidates = collectSuffixCandidates(meta, literalValues, opts);
  if (candidates.length === 0) return alternatives;

  const used = new Set();
  const groupsByStartIndex = new Map();

  for (const candidate of candidates) {
    if (candidate.type === "bridge") {
      const baseIndex = candidate.baseIndexes.find((idx) => !used.has(idx));
      if (baseIndex == null) continue;

      const availableMembers = candidate.members.filter(
        (member) => !used.has(member.index),
      );
      const members = dedupeMembersByIndex(availableMembers);
      if (members.length === 0) continue;
      if (estimateBoundaryBridgeGain(members, meta, candidate.base) <= 0) {
        continue;
      }

      const startIndex = Math.min(baseIndex, members[0].index);
      if (groupsByStartIndex.has(startIndex)) continue;

      groupsByStartIndex.set(startIndex, {
        type: "bridge",
        base: candidate.base,
        baseIndex,
        members,
      });

      used.add(baseIndex);
      for (const member of members) {
        used.add(member.index);
      }
      continue;
    }

    const availableMembers = candidate.members.filter(
      (member) => !used.has(member.index),
    );
    const members = dedupeMembersByIndex(availableMembers);
    if (members.length < 2) continue;

    const startIndex = members[0].index;
    if (groupsByStartIndex.has(startIndex)) continue;
    if (estimateSuffixGroupingGain(members, meta, candidate.suffix) <= 0) {
      continue;
    }

    groupsByStartIndex.set(startIndex, {
      type: "suffix",
      suffix: candidate.suffix,
      members,
    });

    for (const member of members) {
      used.add(member.index);
    }
  }

  if (groupsByStartIndex.size === 0) return alternatives;

  const out = [];
  for (let i = 0; i < alternatives.length; i += 1) {
    const group = groupsByStartIndex.get(i);
    if (group) {
      if (group.type === "bridge") {
        const groupedPrefixes = group.members.map((member) => {
          const value = /** @type {string} */ (meta[member.index].value);
          return literalNode(value.slice(0, member.splitPos));
        });
        const prefixExpr =
          groupedPrefixes.length === 1
            ? concatNode([groupedPrefixes[0], literalNode("_")])
            : concatNode([
                altGroupNode(groupedPrefixes, { force: true }),
                literalNode("_"),
              ]);

        out.push(
          concatNode([
            optionalNode(prefixExpr),
            literalNode(group.base),
          ]),
        );
      } else {
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
      }
      continue;
    }

    if (used.has(i)) continue;
    out.push(alternatives[i]);
  }

  return out;
}

/**
 * @param {Array<{ value: string | null }>} meta
 * @param {Set<string>} literalValues
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {Array<{
 *   type: "suffix" | "bridge",
 *   suffix: string,
 *   kind: "boundary-bridge" | "boundary" | "midword",
 *   affixLen: number,
 *   gain: number,
 *   startIndex: number,
 *   members: Array<{
 *     index: number,
 *     splitPos: number,
 *     boundaryKind: "underscore" | "digit" | "camel" | "midword"
 *   }>,
 *   base?: string,
 *   baseIndexes?: number[]
 * }>}
 */
function collectSuffixCandidates(meta, literalValues, opts) {
  /** @type {Map<string, Array<{
   *   index: number,
   *   splitPos: number,
   *   boundaryKind: "underscore" | "digit" | "camel" | "midword"
   * }>>} */
  const candidateMap = new Map();

  for (const entry of meta) {
    if (entry.value == null) continue;

    for (let splitPos = 1; splitPos < entry.value.length; splitPos += 1) {
      const evaluation = evaluateLiteralSplit(entry.value, splitPos, opts);
      if (!evaluation.allowed) continue;

      const suffix = entry.value.slice(splitPos);
      const prefix = entry.value.slice(0, splitPos);
      if (suffix.length === 0 || prefix.length === 0) continue;

      const members = candidateMap.get(suffix) ?? [];
      members.push({
        index: entry.index,
        splitPos,
        boundaryKind: evaluation.boundaryKind,
      });
      candidateMap.set(suffix, members);
    }
  }

  /** @type {Array<{
   *   type: "suffix" | "bridge",
   *   suffix: string,
   *   kind: "boundary-bridge" | "boundary" | "midword",
   *   affixLen: number,
   *   gain: number,
   *   startIndex: number,
   *   members: Array<{
   *     index: number,
   *     splitPos: number,
   *     boundaryKind: "underscore" | "digit" | "camel" | "midword"
   *   }>,
   *   base?: string,
   *   baseIndexes?: number[]
   * }>} */
  const out = [];

  for (const [suffix, rawMembers] of candidateMap.entries()) {
    const members = dedupeMembersByIndex(rawMembers);
    if (members.length < 2) continue;

    const gain = estimateSuffixGroupingGain(members, meta, suffix);
    if (gain <= 0) continue;

    out.push({
      type: "suffix",
      suffix,
      kind: classifySuffixCandidateKind(suffix, members, literalValues),
      affixLen: suffix.length,
      gain,
      startIndex: members[0].index,
      members,
    });
  }

  const bridgeCandidates = collectBoundaryBridgeCandidates(meta, literalValues, opts);
  out.push(...bridgeCandidates);

  return out.sort(compareSuffixCandidates);
}

/**
 * @param {Array<{ value: string | null }>} meta
 * @param {Set<string>} literalValues
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {Array<{
 *   type: "bridge",
 *   suffix: string,
 *   base: string,
 *   baseIndexes: number[],
 *   kind: "boundary-bridge",
 *   affixLen: number,
 *   gain: number,
 *   startIndex: number,
 *   members: Array<{
 *     index: number,
 *     splitPos: number,
 *     boundaryKind: "underscore" | "digit" | "camel" | "midword"
 *   }>
 * }>}
 */
function collectBoundaryBridgeCandidates(meta, literalValues, opts) {
  /** @type {Map<string, Array<{
   *   index: number,
   *   splitPos: number,
   *   boundaryKind: "underscore" | "digit" | "camel" | "midword"
   * }>>} */
  const membersByBase = new Map();
  /** @type {Map<string, number[]>} */
  const baseIndexes = new Map();

  for (let index = 0; index < meta.length; index += 1) {
    const value = meta[index].value;
    if (value == null) continue;

    const arr = baseIndexes.get(value) ?? [];
    arr.push(index);
    baseIndexes.set(value, arr);

    for (let splitPos = 1; splitPos < value.length; splitPos += 1) {
      if (value[splitPos] !== "_") continue;

      const base = value.slice(splitPos + 1);
      if (base.length === 0 || !literalValues.has(base)) continue;

      const evaluation = evaluateLiteralSplit(value, splitPos, opts);
      if (!evaluation.allowed) continue;

      const members = membersByBase.get(base) ?? [];
      members.push({
        index,
        splitPos,
        boundaryKind: evaluation.boundaryKind,
      });
      membersByBase.set(base, members);
    }
  }

  /** @type {Array<{
   *   type: "bridge",
   *   suffix: string,
   *   base: string,
   *   baseIndexes: number[],
   *   kind: "boundary-bridge",
   *   affixLen: number,
   *   gain: number,
   *   startIndex: number,
   *   members: Array<{
   *     index: number,
   *     splitPos: number,
   *     boundaryKind: "underscore" | "digit" | "camel" | "midword"
   *   }>
   * }>} */
  const out = [];

  for (const [base, rawMembers] of membersByBase.entries()) {
    const indexes = baseIndexes.get(base) ?? [];
    if (indexes.length === 0) continue;

    const members = dedupeMembersByIndex(rawMembers);
    if (members.length === 0) continue;

    const gain = estimateBoundaryBridgeGain(members, meta, base);
    if (gain <= 0) continue;

    out.push({
      type: "bridge",
      suffix: `_${base}`,
      base,
      baseIndexes: indexes,
      kind: "boundary-bridge",
      affixLen: base.length + 1,
      gain,
      startIndex: Math.min(indexes[0], members[0].index),
      members,
    });
  }

  return out;
}

/**
 * @param {Array<{ index: number, splitPos: number, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>} members
 * @returns {Array<{ index: number, splitPos: number, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>}
 */
function dedupeMembersByIndex(members) {
  const byIndex = new Map();

  for (const member of members) {
    if (!byIndex.has(member.index)) {
      byIndex.set(member.index, member);
    }
  }

  return [...byIndex.values()].sort((a, b) => a.index - b.index);
}

/**
 * @param {string} suffix
 * @param {Array<{ index: number, splitPos: number, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>} members
 * @param {Set<string>} literalValues
 * @returns {"boundary-bridge" | "boundary" | "midword"}
 */
function classifySuffixCandidateKind(suffix, members, literalValues) {
  if (isBoundaryBridgeSuffix(suffix, literalValues)) {
    return "boundary-bridge";
  }

  const allBoundary = members.every(
    (member) => member.boundaryKind !== SPLIT_BOUNDARY_KINDS.midword,
  );
  if (allBoundary) return "boundary";
  return "midword";
}

/**
 * @param {{
 *   kind: "boundary-bridge" | "boundary" | "midword",
 *   affixLen: number,
 *   gain: number,
 *   startIndex: number,
 *   suffix: string,
 *   members: Array<{ index: number }>
 * }} a
 * @param {{
 *   kind: "boundary-bridge" | "boundary" | "midword",
 *   affixLen: number,
 *   gain: number,
 *   startIndex: number,
 *   suffix: string,
 *   members: Array<{ index: number }>
 * }} b
 * @returns {number}
 */
function compareSuffixCandidates(a, b) {
  const kindCmp = getCandidateKindPriority(b.kind) - getCandidateKindPriority(a.kind);
  if (kindCmp !== 0) return kindCmp;
  if (b.affixLen !== a.affixLen) return b.affixLen - a.affixLen;
  if (b.gain !== a.gain) return b.gain - a.gain;
  if (b.members.length !== a.members.length) {
    return b.members.length - a.members.length;
  }
  if (a.startIndex !== b.startIndex) return a.startIndex - b.startIndex;
  return a.suffix.localeCompare(b.suffix);
}

/**
 * @param {"boundary-bridge" | "boundary" | "midword"} kind
 * @returns {number}
 */
function getCandidateKindPriority(kind) {
  if (kind === "boundary-bridge") return 3;
  if (kind === "boundary") return 2;
  return 1;
}

/**
 * @param {Array<{ index: number, splitPos: number }>} members
 * @param {Array<{ value: string | null }>} meta
 * @param {string} suffix
 * @returns {number}
 */
function estimateSuffixGroupingGain(members, meta, suffix) {
  const values = members.map((member) => meta[member.index]?.value).filter(Boolean);
  if (values.length !== members.length) return Number.NEGATIVE_INFINITY;

  const originalLen =
    values.reduce((sum, value) => sum + value.length, 0) + (values.length - 1);

  const groupedPrefixesLen = members.reduce((sum, member, idx) => {
    const value = /** @type {string} */ (values[idx]);
    return sum + value.slice(0, member.splitPos).length;
  }, 0);
  const groupedLen = groupedPrefixesLen + (members.length - 1) + 2 + suffix.length;

  return originalLen - groupedLen;
}

/**
 * @param {Array<{ index: number, splitPos: number }>} members
 * @param {Array<{ value: string | null }>} meta
 * @param {string} base
 * @returns {number}
 */
function estimateBoundaryBridgeGain(members, meta, base) {
  const values = members.map((member) => meta[member.index]?.value).filter(Boolean);
  if (values.length !== members.length) return Number.NEGATIVE_INFINITY;

  const originalLen =
    base.length +
    values.reduce((sum, value) => sum + value.length, 0) +
    members.length;

  const prefixLengths = members.map((member, idx) => {
    const value = /** @type {string} */ (values[idx]);
    return value.slice(0, member.splitPos).length;
  });
  const prefixExprLen =
    prefixLengths.length === 1
      ? prefixLengths[0] + 1
      : 2 + prefixLengths.reduce((sum, len) => sum + len, 0) + (prefixLengths.length - 1) + 1;
  const groupedLen = prefixExprLen + 3 + base.length;

  return originalLen - groupedLen;
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
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
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
 * @param {{ forbidSplitWords: Set<string>, forceSplitWords: Set<string> }} opts
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
        opts.forbidSplitWords.has(`${nestedPrefix}${lit}`)
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
        if (opts.forbidSplitWords.has(lit)) {
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
 * @param {{ forceSplitWords: Set<string> }} opts
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
 * @param {Set<string>} forceSet
 * @param {string} suffix
 * @returns {boolean}
 */
function hasForcedSuffix(forceSet, suffix) {
  if (forceSet.size === 0) return false;
  for (const word of forceSet) {
    if (word.endsWith(suffix)) return true;
  }
  return false;
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
