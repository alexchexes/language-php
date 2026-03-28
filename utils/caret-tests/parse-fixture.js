// @ts-check

const { readFileSync } = require("fs");

/**
 * @typedef {{
 *   kind: "bol" | "carets",
 *   lineNumber: number,
 *   rawLine: string,
 *   columns: number[],
 *   selectorText: string,
 *   selectors: string[],
 * }} AssertionLine
 */

/**
 * @typedef {{
 *   sourceLineNumber: number,
 *   sourceLine: string,
 *   cleanedLineIndex: number,
 *   assertions: AssertionLine[],
 * }} Block
 */

/**
 * @typedef {{
 *   path: string,
 *   relativePath: string,
 *   lineEnding: string,
 *   lines: string[],
 *   blocks: Block[],
 *   sourceLineNumbers: number[],
 *   cleanedSource: string,
 * }} ParsedFixture
 */

/**
 * @param {string} selectorText
 * @returns {string[]}
 */
const parseSelectors = (selectorText) =>
  selectorText.trim() ? selectorText.trim().split(/\s+/) : [];

/**
 * @param {string} line
 * @param {number} lineNumber
 * @returns {AssertionLine | null}
 */
const parseAssertionLine = (line, lineNumber) => {
  if (!line.startsWith("#")) return null;

  const rest = line.slice(1);
  const bolMatch = rest.match(/^\s*<-\s*(.*)$/);
  if (bolMatch) {
    const selectorText = bolMatch[1];
    return {
      kind: "bol",
      lineNumber,
      rawLine: line,
      columns: [0],
      selectorText,
      selectors: parseSelectors(selectorText),
    };
  }

  const lastCaret = rest.lastIndexOf("^");
  if (lastCaret === -1) return null;

  const mask = rest.slice(0, lastCaret + 1);
  if (!/^[ \^]+$/.test(mask) || !mask.includes("^")) return null;

  /** @type {number[]} */
  const columns = [];
  for (let index = 0; index < mask.length; index += 1) {
    if (mask[index] === "^") columns.push(index + 1);
  }

  const selectorText = rest.slice(lastCaret + 1).trim();
  return {
    kind: "carets",
    lineNumber,
    rawLine: line,
    columns,
    selectorText,
    selectors: parseSelectors(selectorText),
  };
};

/**
 * @param {string} source
 * @param {string} fixturePath
 * @param {string} relativePath
 * @returns {ParsedFixture}
 */
const parseFixtureSource = (source, fixturePath, relativePath) => {
  const normalized = source.replace(/\r\n/g, "\n");
  const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
  const lines = normalized.split("\n");

  /** @type {Block[]} */
  const blocks = [];
  /** @type {string[]} */
  const cleanedLines = [];
  /** @type {number[]} */
  const sourceLineNumbers = [];

  /** @type {Block | null} */
  let currentBlock = null;

  for (let lineIndex = 0; lineIndex < lines.length; lineIndex += 1) {
    const line = lines[lineIndex];
    const lineNumber = lineIndex + 1;
    const assertion = parseAssertionLine(line, lineNumber);

    if (assertion) {
      if (!currentBlock) {
        throw new Error(
          `${relativePath}:${lineNumber}: assertion line is not attached to a source line`
        );
      }
      currentBlock.assertions.push(assertion);
      continue;
    }

    currentBlock = {
      sourceLineNumber: lineNumber,
      sourceLine: line,
      cleanedLineIndex: cleanedLines.length,
      assertions: [],
    };
    blocks.push(currentBlock);
    cleanedLines.push(line);
    sourceLineNumbers.push(lineNumber);
  }

  return {
    path: fixturePath,
    relativePath,
    lineEnding,
    lines,
    blocks: blocks.filter((block) => block.assertions.length > 0),
    sourceLineNumbers,
    cleanedSource: cleanedLines.join("\n"),
  };
};

/**
 * @param {string} fixturePath
 * @param {string} relativePath
 * @returns {ParsedFixture}
 */
const parseFixtureFile = (fixturePath, relativePath) =>
  parseFixtureSource(readFileSync(fixturePath, "utf8"), fixturePath, relativePath);

module.exports = {
  parseAssertionLine,
  parseFixtureFile,
  parseFixtureSource,
};
