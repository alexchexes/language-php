import assert from "node:assert/strict";
import test from "node:test";
import { resolveOptions } from "../src/config/resolve-options.mjs";
import { evaluateLiteralSplit } from "../src/policy/split-engine.mjs";

function opts(raw = {}) {
  return resolveOptions(raw);
}

test("split-engine: midword split obeys --min-word-split", () => {
  const blocked = evaluateLiteralSplit("ICUVERSION", 1, opts({ minWordSplitLen: 3 }));
  assert.equal(blocked.allowed, false);
  assert.equal(blocked.reason, "midword-threshold");

  const allowed = evaluateLiteralSplit("ICUVERSION", 3, opts({ minWordSplitLen: 3 }));
  assert.equal(allowed.allowed, true);
  assert.equal(allowed.reason, "midword");
});

test("split-engine: underscore/digit/camel boundaries bypass threshold", () => {
  const underscore = evaluateLiteralSplit("E_FOO", 1, opts({ minWordSplitLen: 3 }));
  assert.equal(underscore.allowed, true);
  assert.equal(underscore.reason, "boundary");

  const digit = evaluateLiteralSplit("E2BIG", 1, opts({ minWordSplitLen: 3 }));
  assert.equal(digit.allowed, true);
  assert.equal(digit.reason, "boundary");

  const camel = evaluateLiteralSplit("FoBar", 2, opts({ minWordSplitLen: 3 }));
  assert.equal(camel.allowed, true);
  assert.equal(camel.reason, "boundary");
});

test("split-engine: --split does not bypass unrelated --no-split fragments", () => {
  const blocked = evaluateLiteralSplit(
    "STANDARD",
    3,
    opts({
      minWordSplitLen: 5,
      forbidSplitWords: new Set(["STANDAR"]),
    }),
  );
  assert.equal(blocked.allowed, false);
  assert.equal(blocked.reason, "no-split");

  const stillBlocked = evaluateLiteralSplit(
    "STANDARD",
    3,
    opts({
      minWordSplitLen: 5,
      forbidSplitWords: new Set(["STANDAR"]),
      forceSplitWords: new Set(["STA"]),
    }),
  );
  assert.equal(stillBlocked.allowed, false);
  assert.equal(stillBlocked.reason, "no-split");

  const forcedSameFragment = evaluateLiteralSplit(
    "TTY",
    1,
    opts({
      minWordSplitLen: 1,
      forbidSplitWords: new Set(["TTY"]),
      forceSplitWords: new Set(["TTY"]),
    }),
  );
  assert.equal(forcedSameFragment.allowed, true);
});
