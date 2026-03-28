// @ts-check

const { AssertionError } = require("chai");
const { writeFileSync } = require("fs");
const { parseFixtureFile } = require("./parse-fixture");
const { matchesOrderedSelectors } = require("./matcher");
const { dumpLine } = require("./dump");

/**
 * @param {{ value: string, scopes: string[] }[]} tokens
 * @param {string} line
 */
const buildLineModel = (tokens, line) => {
  /** @type {Map<number, string[]>} */
  const tokenColumns = new Map();
  let offset = 0;

  for (const token of tokens) {
    if (token.value.length === 0) {
      if (!tokenColumns.has(0)) tokenColumns.set(0, token.scopes);
      continue;
    }

    for (let index = 0; index < token.value.length; index += 1) {
      tokenColumns.set(offset + index, token.scopes);
    }
    offset += token.value.length;
  }

  return { line, tokenColumns };
};

/**
 * @param {ReturnType<typeof parseFixtureFile>} fixture
 * @param {{ value: string, scopes: string[] }[][]} tokenizedLines
 */
const buildTokenModel = (fixture, tokenizedLines) => {
  /** @type {Map<number, { line: string, tokenColumns: Map<number, string[]> }>} */
  const bySourceLineNumber = new Map();

  for (const block of fixture.blocks) {
    const tokens = tokenizedLines[block.cleanedLineIndex] || [];
    bySourceLineNumber.set(
      block.sourceLineNumber,
      buildLineModel(tokens, block.sourceLine)
    );
  }

  return bySourceLineNumber;
};

/**
 * @param {Map<number, { line: string, tokenColumns: Map<number, string[]> }>} tokenModel
 * @param {number} sourceLineNumber
 */
const getLineModel = (tokenModel, sourceLineNumber) => {
  const lineModel = tokenModel.get(sourceLineNumber);
  if (!lineModel) {
    throw new Error(`Missing tokenized line model for source line ${sourceLineNumber}`);
  }
  return lineModel;
};

/**
 * @param {ReturnType<typeof parseFixtureFile>["blocks"][number]} block
 */
const blockTargetsLeadingWhitespace = (block) => {
  const firstNonWhitespace = block.sourceLine.search(/[^\t ]/);
  if (firstNonWhitespace === -1) {
    return block.assertions.some((assertion) => assertion.columns.includes(0) || assertion.columns.length > 0);
  }

  return block.assertions.some((assertion) =>
    assertion.columns.some((column) => column < firstNonWhitespace)
  );
};

/**
 * @param {ReturnType<typeof parseFixtureFile>["blocks"][number]} block
 */
const blockTargetsColumnZero = (block) =>
  block.assertions.some((assertion) => assertion.columns.includes(0));

/**
 * @param {ReturnType<typeof parseFixtureFile>["blocks"][number]} block
 * @param {{ line: string, tokenColumns: Map<number, string[]> }} lineModel
 * @param {{ startScope?: string | null }} options
 */
const dumpBlockActual = (block, lineModel, options = {}) =>
  dumpLine(lineModel, {
    startScope: options.startScope || null,
    includeLeadingWhitespace: blockTargetsLeadingWhitespace(block),
    includeColumnZero: blockTargetsColumnZero(block),
  });

/**
 * @param {ReturnType<typeof parseFixtureFile>["blocks"][number]} block
 * @param {{ line: string, tokenColumns: Map<number, string[]> }} lineModel
 * @param {number} column
 * @param {{ startScope?: string | null }} options
 * @param {string[]} selectors
 */
const getFailureActualLine = (block, lineModel, column, options = {}, selectors = []) => {
  const dumpedLines = dumpLine(lineModel, {
    startScope: options.startScope || null,
    includeLeadingWhitespace: blockTargetsLeadingWhitespace(block),
    includeColumnZero: blockTargetsColumnZero(block),
    selectors,
  });

  return (
    dumpedLines.find((dumpedLine) => dumpedLine.columns.includes(column))?.line ||
    `#<no-token-for-column-${column}>`
  );
};

/**
 * @param {ReturnType<typeof parseFixtureFile>["blocks"][number]} block
 * @param {{ line: string, tokenColumns: Map<number, string[]> }} lineModel
 * @param {{ startScope?: string | null, relativePath?: string | null }} options
 */
const assertBlock = (block, lineModel, options = {}) => {
  const failingCarets = [];

  for (const assertion of block.assertions) {
    for (const column of assertion.columns) {
      const actualScopes = lineModel.tokenColumns.get(column) || [];
      const matches = matchesOrderedSelectors(assertion.selectors, actualScopes);
      if (matches) continue;

      const actualLine = getFailureActualLine(
        block,
        lineModel,
        column,
        options,
        assertion.selectors
      );

      failingCarets.push({
        column,
        expectedLine: assertion.rawLine,
        actualLine,
      });
    }
  }

  if (failingCarets.length === 0) return;

  const displayedFailures = failingCarets.slice(0, 5);
  const remainder = failingCarets.length - displayedFailures.length;
  const diffSourceLine = `source\n${block.sourceLine}`;
  const expected = displayedFailures
    .map(
      ({ column, expectedLine }) =>
        `column ${column}\n${expectedLine}`
    )
    .join("\n");
  const actual = displayedFailures
    .map(
      ({ column, actualLine }) =>
        `column ${column}\n${actualLine}`
    )
    .join("\n");
  const summary = remainder > 0 ? `\nshowing first 5 of ${failingCarets.length} failing carets` : "";
  const prefix = options.relativePath ? `${options.relativePath}:` : "";

  throw new AssertionError(
    `${prefix}${block.sourceLineNumber}\n     ${block.sourceLine}${summary}`,
    {
      actual: `${diffSourceLine}\n${actual}`,
      expected: `${diffSourceLine}\n${expected}`,
      showDiff: true,
    },
    assertBlock
  );
};

/**
 * @param {ReturnType<typeof parseFixtureFile>} fixture
 * @param {Map<number, string[]>} replacementBySourceLine
 */
const buildUpdatedFixtureText = (fixture, replacementBySourceLine) => {
  const output = [];

  for (let lineIndex = 0; lineIndex < fixture.lines.length; lineIndex += 1) {
    const lineNumber = lineIndex + 1;
    const block = fixture.blocks.find(
      (candidate) => candidate.sourceLineNumber === lineNumber
    );

    if (!block) {
      const isAssertionLine = fixture.blocks.some((candidate) =>
        candidate.assertions.some((assertion) => assertion.lineNumber === lineNumber)
      );
      if (!isAssertionLine) output.push(fixture.lines[lineIndex]);
      continue;
    }

    output.push(block.sourceLine);
    const replacement = replacementBySourceLine.get(block.sourceLineNumber);
    if (replacement) {
      output.push(...replacement);
    } else {
      output.push(...block.assertions.map((assertion) => assertion.rawLine));
    }

    lineIndex += block.assertions.length;
  }

  return output.join(fixture.lineEnding);
};

/**
 * @param {ReturnType<typeof parseFixtureFile>} fixture
 * @param {Map<number, string[]>} replacementBySourceLine
 */
const writeUpdatedFixture = (fixture, replacementBySourceLine) => {
  const updatedText = buildUpdatedFixtureText(fixture, replacementBySourceLine);
  writeFileSync(fixture.path, updatedText, "utf8");
};

module.exports = {
  assertBlock,
  buildLineModel,
  buildTokenModel,
  dumpBlockActual,
  getFailureActualLine,
  getLineModel,
  parseFixtureFile,
  writeUpdatedFixture,
};
