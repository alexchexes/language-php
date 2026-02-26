import assert from "node:assert/strict";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import {
  FIXTURES_DIR,
  loadFixture,
  normalizeLineEndings,
  runRegexBuilder,
} from "./fixture-utils.mjs";

async function withTempInput(lines, fn) {
  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), "regex-builder-"));
  const inputPath = path.join(tempDir, "input.txt");

  try {
    await fs.writeFile(inputPath, `${lines.join("\n")}\n`, "utf8");
    return await fn(inputPath);
  } finally {
    await fs.rm(tempDir, { recursive: true, force: true });
  }
}

function runCompact(inputPath, args = []) {
  const result = runRegexBuilder({ inputPath, args, compact: true });
  assert.equal(result.status, 0, result.stderr || result.stdout);
  return normalizeLineEndings(result.stdout).trim();
}

test("metamorphic: compact output is stable for permutation + duplicates", async () => {
  const fixture = await loadFixture(path.join(FIXTURES_DIR, "min-word-split-so-sort"), {
    requireExpected: true,
  });
  const raw = await fs.readFile(fixture.inputPath, "utf8");
  const lines = raw
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);

  const baseline = await withTempInput(lines, async (inputPath) =>
    runCompact(inputPath),
  );
  const reversed = await withTempInput([...lines].reverse(), async (inputPath) =>
    runCompact(inputPath),
  );
  const duplicated = await withTempInput([...lines, ...lines.slice(0, 5)], async (inputPath) =>
    runCompact(inputPath),
  );

  assert.equal(reversed, baseline);
  assert.equal(duplicated, baseline);
});

test("metamorphic: wrap + indent do not affect compact output", async () => {
  const fixture = await loadFixture(path.join(FIXTURES_DIR, "indent-auto"), {
    requireExpected: true,
  });

  const a = runCompact(fixture.inputPath, ["--indent", "auto", "--wrap", "100"]);
  const b = runCompact(fixture.inputPath, ["--indent", "2", "--wrap", "40"]);
  const c = runCompact(fixture.inputPath, ["--indent", "4", "--wrap", "200"]);

  assert.equal(a, b);
  assert.equal(b, c);
});

test("metamorphic: pretty and compact are semantically equivalent", async () => {
  const fixture = await loadFixture(path.join(FIXTURES_DIR, "mixed-format-wrap"), {
    requireExpected: true,
  });

  const prettyRun = runRegexBuilder({
    inputPath: fixture.inputPath,
    args: fixture.args,
  });
  assert.equal(prettyRun.status, 0, prettyRun.stderr || prettyRun.stdout);

  const compactRun = runRegexBuilder({
    inputPath: fixture.inputPath,
    args: fixture.args,
    compact: true,
  });
  assert.equal(compactRun.status, 0, compactRun.stderr || compactRun.stdout);

  const prettyPattern = normalizeLineEndings(prettyRun.stdout).replace(/\s+/g, "");
  const compactPattern = normalizeLineEndings(compactRun.stdout).trim();
  const prettyRegex = new RegExp(`\\b(?:${prettyPattern})\\b`);
  const compactRegex = new RegExp(`\\b(?:${compactPattern})\\b`);

  for (const value of fixture.positives) {
    assert.equal(prettyRegex.test(value), true, value);
    assert.equal(compactRegex.test(value), true, value);
  }

  for (const value of fixture.negatives) {
    assert.equal(prettyRegex.test(value), false, value);
    assert.equal(compactRegex.test(value), false, value);
  }
});
