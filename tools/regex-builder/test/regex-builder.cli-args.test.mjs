import assert from "node:assert/strict";
import test from "node:test";
import { parseArgs } from "../src/cli/parse-args.mjs";

function setValues(set) {
  return [...set].sort();
}

test("cli args: value options accept both --opt value and --opt=value", () => {
  const spaced = parseArgs([
    "input.txt",
    "--indent",
    "auto",
    "--wrap",
    "120",
    "--min-word-split",
    "4",
    "--no-split",
    "FOO,BAR",
    "--split",
    "BAZ,QUX",
  ]);
  const equals = parseArgs([
    "input.txt",
    "--indent=auto",
    "--wrap=120",
    "--min-word-split=4",
    "--no-split=FOO,BAR",
    "--split=BAZ,QUX",
  ]);

  assert.equal(spaced.indent, equals.indent);
  assert.equal(spaced.wrap, equals.wrap);
  assert.equal(spaced.minWordSplitLen, equals.minWordSplitLen);
  assert.deepEqual(setValues(spaced.forbidSplitWords), setValues(equals.forbidSplitWords));
  assert.deepEqual(setValues(spaced.forceSplitWords), setValues(equals.forceSplitWords));
});

test("cli args: --balanced defaults wrap to 100 and supports value forms", () => {
  const a = parseArgs(["input.txt", "--balanced"]);
  const b = parseArgs(["input.txt", "--balanced=140"]);
  const c = parseArgs(["input.txt", "--balanced", "140"]);

  assert.equal(a.format, "balanced");
  assert.equal(a.wrap, 100);
  assert.equal(b.format, "balanced");
  assert.equal(b.wrap, 140);
  assert.equal(c.format, "balanced");
  assert.equal(c.wrap, 140);
});

test("cli args: missing value detection still works", () => {
  assert.throws(
    () => parseArgs(["input.txt", "--wrap"]),
    /Missing value for --wrap/u,
  );
  assert.throws(
    () => parseArgs(["input.txt", "--wrap", "--pretty"]),
    /Missing value for --wrap/u,
  );
  assert.throws(
    () => parseArgs(["input.txt", "--min-word-split="]),
    /Missing value for --min-word-split/u,
  );
});
