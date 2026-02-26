/**
 * @typedef {{
 *   pretty?: boolean,
 *   json?: boolean,
 *   groupStyle?: "capturing" | "noncapturing",
 *   indent?: number | "auto",
 *   wrap?: number,
 *   minWordSplitLen?: number,
 *   forbidSplitWords?: Set<string>,
 *   forceSplitWords?: Set<string>
 * }} RawOptions
 */

/**
 * @typedef {{
 *   pretty: boolean,
 *   json: boolean,
 *   groupStyle: "capturing" | "noncapturing",
 *   indent: number | "auto",
 *   wrap: number,
 *   minWordSplitLen: number,
 *   forbidSplitWords: Set<string>,
 *   forceSplitWords: Set<string>
 * }} ResolvedOptions
 */

/**
 * @param {RawOptions} [raw]
 * @returns {ResolvedOptions}
 */
export function resolveOptions(raw = {}) {
  return {
    pretty: raw.pretty ?? true,
    json: raw.json ?? false,
    groupStyle:
      raw.groupStyle === "noncapturing" ? "noncapturing" : "capturing",
    indent: resolveIndent(raw.indent),
    wrap: resolvePositiveNumber(raw.wrap, 100),
    minWordSplitLen: resolveNonNegativeNumber(raw.minWordSplitLen, 3),
    forbidSplitWords: cloneStringSet(raw.forbidSplitWords),
    forceSplitWords: cloneStringSet(raw.forceSplitWords),
  };
}

/**
 * @param {number | "auto" | undefined} value
 * @returns {number | "auto"}
 */
function resolveIndent(value) {
  if (value === "auto" || value == null) return "auto";
  return resolveNonNegativeNumber(value, 0);
}

/**
 * @param {Set<string> | undefined} source
 * @returns {Set<string>}
 */
function cloneStringSet(source) {
  if (!source || source.size === 0) return new Set();
  return new Set(source);
}

/**
 * @param {number | undefined} value
 * @param {number} fallback
 * @returns {number}
 */
function resolvePositiveNumber(value, fallback) {
  if (!Number.isFinite(value) || value <= 0) return fallback;
  return value;
}

/**
 * @param {number | undefined} value
 * @param {number} fallback
 * @returns {number}
 */
function resolveNonNegativeNumber(value, fallback) {
  if (!Number.isFinite(value) || value < 0) return fallback;
  return value;
}
