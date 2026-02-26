import { IR_NODE_KINDS } from "../../types.mjs";
import { altGroupNode, concatNode, literalNode } from "../../node-utils.mjs";
import { getWholeLiteralValue } from "./literal-utils.mjs";

/**
 * Extract a nested forced split into a sibling alternative.
 *
 * Example:
 *   NO(...|T(BLK|...|TY|...)) -> NO(...|TTY)|NOT(BLK|...|...)
 *
 * @param {import("../../types.mjs").RegexIR[]} alternatives
 * @param {{
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} opts
 * @returns {import("../../types.mjs").RegexIR[]}
 */
export function regroupByForcedNestedPrefix(alternatives, opts) {
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
 * @param {import("../../types.mjs").RegexIR} alt
 * @param {{ forbidSplitWords: Set<string>, forceSplitWords: Set<string> }} opts
 * @returns {{ parent: import("../../types.mjs").RegexIR, sibling: import("../../types.mjs").RegexIR } | null}
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
      if (lit != null && opts.forbidSplitWords.has(`${nestedPrefix}${lit}`)) {
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
  for (const nestedPrefix of collectForcedNestedPrefixes(
    outerAlts,
    outerPrefix,
    opts,
  )) {
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
 * @param {import("../../types.mjs").RegexIR} node
 * @returns {{ prefix: string, group: import("../../types.mjs").AltGroupNode } | null}
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
 * @param {import("../../types.mjs").RegexIR[]} outerAlts
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

