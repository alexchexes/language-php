// @ts-check

const { assertsBeforeStartScope } = require("./matcher");

/**
 * @typedef {{
 *   line: string,
 *   tokenColumns: Map<number, string[]>,
 * }} LineModel
 */

/**
 * @typedef {{
 *   startScope?: string | null,
 *   includeLeadingWhitespace?: boolean,
 *   includeColumnZero?: boolean,
 *   selectors?: string[],
 * }} DumpOptions
 */

/**
 * @param {string[]} scopes
 * @param {DumpOptions} options
 * @returns {string[]}
 */
const renderScopes = (scopes, options = {}) => {
  const { startScope = null, selectors = [] } = options;
  if (!startScope) return scopes;

  const startIndex = scopes.indexOf(startScope);
  if (startIndex === -1) return scopes;
  if (selectors.length > 0 && assertsBeforeStartScope(selectors, scopes, startScope)) {
    return scopes;
  }
  return scopes.slice(startIndex);
};

/**
 * @param {number[]} columns
 * @returns {string}
 */
const formatCaretMask = (columns) => {
  const maxColumn = Math.max(...columns);
  const chars = Array.from({ length: maxColumn }, () => " ");
  for (const column of columns) {
    if (column <= 0) continue;
    chars[column - 1] = "^";
  }
  return chars.join("");
};

/**
 * @param {number[]} columns
 * @param {string} payload
 * @returns {string}
 */
const formatCaretLine = (columns, payload) => {
  const mask = formatCaretMask(columns);
  return payload ? `#${mask} ${payload}` : `#${mask}`;
};

/**
 * @param {string} payload
 * @returns {string}
 */
const formatBolLine = (payload) => (payload ? `#<-${payload}` : "#<-");

/**
 * @param {LineModel} lineModel
 * @param {DumpOptions} options
 */
const dumpLine = (lineModel, options = {}) => {
  const includeLeadingWhitespace = options.includeLeadingWhitespace === true;
  const includeColumnZero = options.includeColumnZero === true || lineModel.line.length === 0;

  /** @type {Map<string, number[]>} */
  const groupedColumns = new Map();
  /** @type {string | null} */
  let columnZeroPayload = null;

  const firstNonWhitespace = lineModel.line.search(/[^\t ]/);
  const leadingWhitespaceEnd =
    firstNonWhitespace === -1 ? lineModel.line.length : firstNonWhitespace;

  /**
   * @param {number} column
   */
  const shouldIncludeColumn = (column) => {
    if (column === 0) return includeColumnZero;
    if (column < leadingWhitespaceEnd) return includeLeadingWhitespace;
    return true;
  };

  for (const [column, scopes] of lineModel.tokenColumns.entries()) {
    if (!shouldIncludeColumn(column)) continue;

    const payloadScopes = renderScopes(scopes, options);
    const payload = payloadScopes.join(" ");

    if (column === 0) {
      columnZeroPayload = payload;
      continue;
    }

    const existing = groupedColumns.get(payload) || [];
    existing.push(column);
    groupedColumns.set(payload, existing);
  }

  /** @type {{ line: string, columns: number[] }[]} */
  const dumpedLines = [];
  if (columnZeroPayload !== null) {
    dumpedLines.push({
      line: formatBolLine(columnZeroPayload),
      columns: [0],
    });
  }

  const groupedEntries = Array.from(groupedColumns.entries())
    .map(([payload, columns]) => ({
      payload,
      columns: columns.sort((left, right) => left - right),
    }))
    .sort((left, right) => left.columns[0] - right.columns[0]);

  for (const { payload, columns } of groupedEntries) {
    dumpedLines.push({
      line: formatCaretLine(columns, payload),
      columns,
    });
  }

  return dumpedLines;
};

module.exports = {
  dumpLine,
  renderScopes,
};
