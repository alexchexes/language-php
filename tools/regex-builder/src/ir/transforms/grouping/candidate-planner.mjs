import { SPLIT_BOUNDARY_KINDS, evaluateLiteralSplit } from "../../../policy/split-engine.mjs";
import { altGroupNode, concatNode, literalNode, optionalNode } from "../../node-utils.mjs";
import {
  getLeadingLiteral,
  getWholeLiteralValue,
  removePrefixFromLeadingLiteral,
} from "./literal-utils.mjs";

/**
 * Apply deterministic affix grouping to an alternative list.
 * This planner is structure-only; render/layout concerns are separate.
 *
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {import("../../types.mjs").RegexIR[]}
 */
export function applyAffixGroupingPlanner(alternatives, opts) {
  let current = groupByUnderscoreLeadingPrefix(alternatives);

  while (true) {
    const candidate = pickBestLiteralCandidate(current, opts);
    if (!candidate) break;

    const next = applyLiteralCandidate(current, candidate);
    if (next === current) break;
    current = next;
  }

  return current;
}

/**
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @returns {import("../../types.mjs").RegexIR[]}
 */
function groupByUnderscoreLeadingPrefix(alternatives) {
  let current = alternatives;

  while (true) {
    const candidate = pickBestLeadingPrefixCandidate(current);
    if (!candidate) break;

    const next = applyLeadingPrefixCandidate(current, candidate);
    if (next === current) break;
    current = next;
  }

  return current;
}

/**
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @returns {{ prefix: string, memberIndexes: number[] } | null}
 */
function pickBestLeadingPrefixCandidate(alternatives) {
  const meta = alternatives.map((alt, index) => ({
    index,
    leadingLiteral: getLeadingLiteral(alt),
  }));
  const prefixMap = new Map();

  for (const entry of meta) {
    if (typeof entry.leadingLiteral !== "string") continue;

    for (let i = 0; i < entry.leadingLiteral.length; i += 1) {
      if (entry.leadingLiteral[i] !== "_") continue;
      const prefix = entry.leadingLiteral.slice(0, i + 1);
      const arr = prefixMap.get(prefix) ?? [];
      arr.push(entry.index);
      prefixMap.set(prefix, arr);
    }
  }

  /** @type {Array<{ prefix: string, memberIndexes: number[] }>} */
  const candidates = [];
  for (const [prefix, rawIndexes] of prefixMap.entries()) {
    const memberIndexes = [...new Set(rawIndexes)].sort((a, b) => a - b);
    if (memberIndexes.length < 2) continue;
    candidates.push({ prefix, memberIndexes });
  }

  if (candidates.length === 0) return null;

  candidates.sort((a, b) => {
    if (b.memberIndexes.length !== a.memberIndexes.length) {
      return b.memberIndexes.length - a.memberIndexes.length;
    }
    if (b.prefix.length !== a.prefix.length) {
      return b.prefix.length - a.prefix.length;
    }
    return a.memberIndexes[0] - b.memberIndexes[0];
  });

  return candidates[0];
}

/**
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @param {{ prefix: string, memberIndexes: number[] }} candidate
 * @returns {import("../../types.mjs").RegexIR[]}
 */
function applyLeadingPrefixCandidate(alternatives, candidate) {
  const memberSet = new Set(candidate.memberIndexes);
  const startIndex = candidate.memberIndexes[0];
  const groupedSuffixes = candidate.memberIndexes.map((idx) =>
    removePrefixFromLeadingLiteral(alternatives[idx], candidate.prefix),
  );
  const replacement = concatNode([
    literalNode(candidate.prefix),
    altGroupNode(groupedSuffixes, { force: true }),
  ]);

  /** @type {import("../../types.mjs").RegexIR[]} */
  const out = [];
  for (let i = 0; i < alternatives.length; i += 1) {
    if (i === startIndex) {
      out.push(replacement);
      continue;
    }
    if (memberSet.has(i)) continue;
    out.push(alternatives[i]);
  }

  return out;
}

/**
 * @typedef {"prefix" | "suffix" | "prefixBridge" | "suffixBridge"} CandidateType
 */

/**
 * @typedef {{
 *   type: CandidateType,
 *   affix: string,
 *   coverage: number,
 *   cohesion: number,
 *   boundaryClass: "boundary" | "midword",
 *   startIndex: number,
 *   members: Array<{
 *     index: number,
 *     splitPos: number,
 *     piece: string,
 *     boundaryKind: "underscore" | "digit" | "camel" | "midword"
 *   }>,
 *   baseIndex?: number
 * }} LiteralCandidate
 */

/**
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {LiteralCandidate | null}
 */
function pickBestLiteralCandidate(alternatives, opts) {
  const literalEntries = alternatives
    .map((alt, index) => ({
      index,
      value: getWholeLiteralValue(alt),
    }))
    .filter((entry) => typeof entry.value === "string");

  if (literalEntries.length < 2) return null;

  /** @type {Map<string, Map<number, { index: number, splitPos: number, piece: string, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>>} */
  const prefixMap = new Map();
  /** @type {Map<string, Map<number, { index: number, splitPos: number, piece: string, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>>} */
  const suffixMap = new Map();
  /** @type {Map<string, number>} */
  const literalIndexByValue = new Map();

  for (const entry of literalEntries) {
    literalIndexByValue.set(entry.value, entry.index);
  }

  for (const entry of literalEntries) {
    for (let splitPos = 1; splitPos < entry.value.length; splitPos += 1) {
      const evaluation = evaluateLiteralSplit(entry.value, splitPos, opts);
      if (!evaluation.allowed) continue;

      const prefix = entry.value.slice(0, splitPos);
      const suffix = entry.value.slice(splitPos);
      if (prefix.length === 0 || suffix.length === 0) continue;

      upsertCandidateMember(prefixMap, prefix, {
        index: entry.index,
        splitPos,
        piece: suffix,
        boundaryKind: evaluation.boundaryKind,
      });
      upsertCandidateMember(suffixMap, suffix, {
        index: entry.index,
        splitPos,
        piece: prefix,
        boundaryKind: evaluation.boundaryKind,
      });
    }
  }

  /** @type {LiteralCandidate[]} */
  const candidates = [];

  for (const [affix, membersByIndex] of prefixMap.entries()) {
    const members = normalizeMembers(membersByIndex);
    if (members.length >= 2) {
      candidates.push({
        type: "prefix",
        affix,
        coverage: members.length,
        cohesion: computeMemberCohesion(members),
        boundaryClass: classifyBoundaryClass(members),
        startIndex: members[0].index,
        members,
      });
    }

    const baseIndex = literalIndexByValue.get(affix);
    if (baseIndex != null && members.length >= 1) {
      candidates.push({
        type: "prefixBridge",
        affix,
        coverage: members.length + 1,
        cohesion: computeMemberCohesion(members),
        boundaryClass: classifyBoundaryClass(members),
        startIndex: Math.min(baseIndex, members[0].index),
        members,
        baseIndex,
      });
    }
  }

  for (const [affix, membersByIndex] of suffixMap.entries()) {
    const members = normalizeMembers(membersByIndex);
    if (members.length >= 2) {
      candidates.push({
        type: "suffix",
        affix,
        coverage: members.length,
        cohesion: computeMemberCohesion(members),
        boundaryClass: classifyBoundaryClass(members),
        startIndex: members[0].index,
        members,
      });
    }

    const baseIndex = literalIndexByValue.get(affix);
    if (baseIndex != null && members.length >= 1) {
      candidates.push({
        type: "suffixBridge",
        affix,
        coverage: members.length + 1,
        cohesion: computeMemberCohesion(members),
        boundaryClass: classifyBoundaryClass(members),
        startIndex: Math.min(baseIndex, members[0].index),
        members,
        baseIndex,
      });
    }
  }

  if (candidates.length === 0) return null;

  const filtered = candidates.filter((candidate) =>
    isLiteralCandidateAdmissible(candidate, opts),
  );
  if (filtered.length === 0) return null;

  filtered.sort(compareLiteralCandidates);
  return filtered[0];
}

/**
 * @param {Map<string, Map<number, { index: number, splitPos: number, piece: string, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>>} map
 * @param {string} key
 * @param {{ index: number, splitPos: number, piece: string, boundaryKind: "underscore" | "digit" | "camel" | "midword" }} member
 */
function upsertCandidateMember(map, key, member) {
  const byIndex = map.get(key) ?? new Map();
  if (!byIndex.has(member.index)) {
    byIndex.set(member.index, member);
    map.set(key, byIndex);
    return;
  }

  // Keep first stable split for this literal+affix key.
  map.set(key, byIndex);
}

/**
 * @param {Map<number, { index: number, splitPos: number, piece: string, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>} membersByIndex
 * @returns {Array<{ index: number, splitPos: number, piece: string, boundaryKind: "underscore" | "digit" | "camel" | "midword" }>}
 */
function normalizeMembers(membersByIndex) {
  return [...membersByIndex.values()].sort((a, b) => a.index - b.index);
}

/**
 * @param {Array<{ boundaryKind: "underscore" | "digit" | "camel" | "midword" }>} members
 * @returns {"boundary" | "midword"}
 */
function classifyBoundaryClass(members) {
  const hasMidword = members.some(
    (member) => member.boundaryKind === SPLIT_BOUNDARY_KINDS.midword,
  );
  return hasMidword ? "midword" : "boundary";
}

/**
 * @param {LiteralCandidate} a
 * @param {LiteralCandidate} b
 * @returns {number}
 */
function compareLiteralCandidates(a, b) {
  const boundaryCmp =
    getBoundaryClassPriority(b.boundaryClass) -
    getBoundaryClassPriority(a.boundaryClass);
  if (boundaryCmp !== 0) return boundaryCmp;

  if (b.coverage !== a.coverage) {
    return b.coverage - a.coverage;
  }

  const kindCmp = getCandidateTypePriority(b.type) - getCandidateTypePriority(a.type);
  if (kindCmp !== 0) return kindCmp;

  if (b.affix.length !== a.affix.length) {
    return b.affix.length - a.affix.length;
  }

  if (a.startIndex !== b.startIndex) {
    return a.startIndex - b.startIndex;
  }

  return a.affix.localeCompare(b.affix);
}

/**
 * @param {LiteralCandidate} candidate
 * @param {{
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {boolean}
 */
function isLiteralCandidateAdmissible(candidate, opts) {
  // Midword 2-member groupings with no shared internal structure are noisy
  // and drive unreadable pair splits like LIMIT/START -> (LIMI|STAR)T.
  if (
    candidate.boundaryClass === "midword" &&
    candidate.members.length === 2 &&
    candidate.cohesion === 0
  ) {
    return false;
  }

  return true;
}

/**
 * @param {Array<{ piece: string }>} members
 * @returns {number}
 */
function computeMemberCohesion(members) {
  if (members.length < 2) return 0;
  const values = members.map((member) => member.piece);
  return Math.max(commonPrefixLen(values), commonSuffixLen(values));
}

/**
 * @param {string[]} values
 * @returns {number}
 */
function commonPrefixLen(values) {
  if (values.length === 0) return 0;
  const first = values[0];
  let len = first.length;

  for (let i = 1; i < values.length; i += 1) {
    const current = values[i];
    let j = 0;
    const max = Math.min(len, current.length);
    while (j < max && first[j] === current[j]) j += 1;
    len = j;
    if (len === 0) break;
  }

  return len;
}

/**
 * @param {string[]} values
 * @returns {number}
 */
function commonSuffixLen(values) {
  if (values.length === 0) return 0;
  const first = values[0];
  let len = first.length;

  for (let i = 1; i < values.length; i += 1) {
    const current = values[i];
    let j = 0;
    const max = Math.min(len, current.length);
    while (j < max && first[first.length - 1 - j] === current[current.length - 1 - j]) {
      j += 1;
    }
    len = j;
    if (len === 0) break;
  }

  return len;
}

/**
 * @param {"boundary" | "midword"} kind
 * @returns {number}
 */
function getBoundaryClassPriority(kind) {
  return kind === "boundary" ? 2 : 1;
}

/**
 * @param {CandidateType} type
 * @returns {number}
 */
function getCandidateTypePriority(type) {
  switch (type) {
    case "prefix":
      return 4;
    case "prefixBridge":
      return 3;
    case "suffix":
      return 2;
    case "suffixBridge":
      return 1;
    default:
      return 0;
  }
}

/**
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @param {LiteralCandidate} candidate
 * @returns {import("../../types.mjs").RegexIR[]}
 */
function applyLiteralCandidate(alternatives, candidate) {
  const memberSet = new Set(candidate.members.map((member) => member.index));
  const startIndex =
    candidate.baseIndex == null
      ? candidate.members[0].index
      : Math.min(candidate.baseIndex, candidate.members[0].index);
  const replacement = buildCandidateReplacement(candidate);

  /** @type {import("../../types.mjs").RegexIR[]} */
  const out = [];
  for (let i = 0; i < alternatives.length; i += 1) {
    if (i === startIndex) {
      out.push(replacement);
      continue;
    }

    if (candidate.baseIndex === i) continue;
    if (memberSet.has(i)) continue;
    out.push(alternatives[i]);
  }

  return out;
}

/**
 * @param {LiteralCandidate} candidate
 * @returns {import("../../types.mjs").RegexIR}
 */
function buildCandidateReplacement(candidate) {
  switch (candidate.type) {
    case "prefix": {
      const suffixes = candidate.members.map((member) => literalNode(member.piece));
      return concatNode([
        literalNode(candidate.affix),
        altGroupNode(suffixes, { force: true }),
      ]);
    }

    case "suffix": {
      const prefixes = candidate.members.map((member) => literalNode(member.piece));
      return concatNode([
        altGroupNode(prefixes, { force: true }),
        literalNode(candidate.affix),
      ]);
    }

    case "prefixBridge": {
      const suffixExpr = optionalChildFromLiterals(
        candidate.members.map((member) => member.piece),
      );
      return concatNode([
        literalNode(candidate.affix),
        optionalNode(suffixExpr),
      ]);
    }

    case "suffixBridge": {
      const prefixExpr = optionalChildFromLiterals(
        candidate.members.map((member) => member.piece),
      );
      return concatNode([
        optionalNode(prefixExpr),
        literalNode(candidate.affix),
      ]);
    }

    default:
      return literalNode("");
  }
}

/**
 * @param {string[]} values
 * @returns {import("../../types.mjs").RegexIR}
 */
function optionalChildFromLiterals(values) {
  if (values.length === 1) return literalNode(values[0]);
  return altGroupNode(values.map((value) => literalNode(value)), { force: true });
}
