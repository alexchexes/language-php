import fs from "node:fs/promises";
import {
  ensureTrailingNewline,
  formatCliCommand,
  formatSpawnFailure,
  listFixtureDirs,
  loadFixture,
  normalizeLineEndings,
  runRegexBuilder,
} from "./fixture-utils.mjs";

async function main() {
  const fixtureDirs = await listFixtureDirs();

  if (fixtureDirs.length === 0) {
    throw new Error(
      "No fixtures found. Add fixture directories under tools/regex-builder/test/fixtures.",
    );
  }

  for (const fixtureDir of fixtureDirs) {
    const fixture = await loadFixture(fixtureDir, { requireExpected: false });

    const prettyCommand = formatCliCommand(
      fixture.inputPath,
      fixture.args,
      false,
    );
    const compactCommand = formatCliCommand(
      fixture.inputPath,
      fixture.args,
      true,
    );

    const prettyRun = runRegexBuilder({
      inputPath: fixture.inputPath,
      args: fixture.args,
    });
    if (prettyRun.status !== 0) {
      throw new Error(
        formatSpawnFailure(
          `[${fixture.id}] pretty CLI`,
          prettyRun,
          prettyCommand,
        ),
      );
    }

    const compactRun = runRegexBuilder({
      inputPath: fixture.inputPath,
      args: fixture.args,
      compact: true,
    });
    if (compactRun.status !== 0) {
      throw new Error(
        formatSpawnFailure(
          `[${fixture.id}] compact CLI`,
          compactRun,
          compactCommand,
        ),
      );
    }

    const prettyOutput = ensureTrailingNewline(
      normalizeLineEndings(prettyRun.stdout),
    );
    const compactOutput = ensureTrailingNewline(
      normalizeLineEndings(compactRun.stdout),
    );

    await fs.writeFile(fixture.expectedPrettyPath, prettyOutput, "utf8");
    await fs.writeFile(fixture.expectedCompactPath, compactOutput, "utf8");

    console.log(`[updated] ${fixture.id}`);
  }
}

main().catch((err) => {
  console.error(err?.stack || String(err));
  process.exit(1);
});
