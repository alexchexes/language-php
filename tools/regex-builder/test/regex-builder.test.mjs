import fs from "node:fs/promises";
import path from "node:path";
import assert from "node:assert/strict";
import test from "node:test";
import {
  UPDATE_HINT,
  formatCliCommand,
  formatSpawnFailure,
  listFixtureDirs,
  loadFixture,
  normalizeLineEndings,
  runRegexBuilder,
} from "./fixture-utils.mjs";

const fixtureDirs = await listFixtureDirs();

test("regex-builder fixtures exist", () => {
  assert.ok(
    fixtureDirs.length > 0,
    "No fixtures found. Add fixture directories under tools/regex-builder/test/fixtures.",
  );
});

for (const fixtureDir of fixtureDirs) {
  const fixtureName = path.basename(fixtureDir);

  test(`regex-builder fixture: ${fixtureName}`, async () => {
    const fixture = await loadFixture(fixtureDir, { requireExpected: true });

    const prettyCommand = formatCliCommand(fixture.inputPath, fixture.args, false);
    const compactCommand = formatCliCommand(fixture.inputPath, fixture.args, true);

    const prettyRun = runRegexBuilder({
      inputPath: fixture.inputPath,
      args: fixture.args,
    });
    assert.equal(
      prettyRun.status,
      0,
      formatSpawnFailure(`[${fixture.id}] pretty CLI`, prettyRun, prettyCommand),
    );

    const compactRun = runRegexBuilder({
      inputPath: fixture.inputPath,
      args: fixture.args,
      compact: true,
    });
    assert.equal(
      compactRun.status,
      0,
      formatSpawnFailure(
        `[${fixture.id}] compact CLI`,
        compactRun,
        compactCommand,
      ),
    );

    const prettyOutput = normalizeLineEndings(prettyRun.stdout);
    const compactOutput = normalizeLineEndings(compactRun.stdout);

    const expectedPretty = normalizeLineEndings(
      await fs.readFile(fixture.expectedPrettyPath, "utf8"),
    );
    const expectedCompact = normalizeLineEndings(
      await fs.readFile(fixture.expectedCompactPath, "utf8"),
    );

    assert.equal(
      prettyOutput,
      expectedPretty,
      `[${fixture.id}] Pretty output mismatch.\n${UPDATE_HINT}`,
    );
    assert.equal(
      compactOutput,
      expectedCompact,
      `[${fixture.id}] Compact output mismatch.\n${UPDATE_HINT}`,
    );

    const compactPattern = compactOutput.trim();
    const prettyWithoutWhitespace = prettyOutput.replace(/\s+/g, "");
    assert.equal(
      compactPattern,
      prettyWithoutWhitespace,
      `[${fixture.id}] Compact output must equal pretty output with whitespace removed.`,
    );

    let boundaryRegex;
    try {
      boundaryRegex = new RegExp(`\\b(?:${compactPattern})\\b`);
    } catch (err) {
      assert.fail(
        `[${fixture.id}] Failed to build boundary regex from compact output: ${err.message}`,
      );
    }

    for (const value of fixture.positives) {
      assert.equal(
        boundaryRegex.test(value),
        true,
        `[${fixture.id}] Expected regex to match positive sample: "${value}"`,
      );
    }

    for (const value of fixture.negatives) {
      assert.equal(
        boundaryRegex.test(value),
        false,
        `[${fixture.id}] Expected regex NOT to match negative sample: "${value}"`,
      );
    }
  });
}
