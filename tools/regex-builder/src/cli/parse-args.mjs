function addCsvWordsToSet(set, raw) {
  if (raw == null) return;

  for (const part of String(raw).split(",")) {
    const word = part.trim();
    if (!word) continue;
    set.add(word);
  }
}

function isOptionToken(raw) {
  return raw === "-h" || raw.startsWith("--");
}

function readOptionValue(argv, index, optionName, config = {}) {
  const { optional = false, defaultValue = null } = config;
  const arg = argv[index];
  const eqPrefix = `${optionName}=`;

  if (arg.startsWith(eqPrefix)) {
    const raw = arg.slice(eqPrefix.length);
    if (raw === "") {
      if (optional) return { raw: defaultValue, nextIndex: index };
      throw new Error(`Missing value for ${optionName}`);
    }
    return { raw, nextIndex: index };
  }

  if (arg !== optionName) return null;

  const next = argv[index + 1];
  if (next == null) {
    if (optional) return { raw: defaultValue, nextIndex: index };
    throw new Error(`Missing value for ${optionName}`);
  }

  if (isOptionToken(next)) {
    if (optional) return { raw: defaultValue, nextIndex: index };
    throw new Error(`Missing value for ${optionName}`);
  }

  return { raw: next, nextIndex: index + 1 };
}

function readNumber(raw, optionName, min = null) {
  const value = Number(raw);
  if (!Number.isFinite(value)) {
    throw new Error(`Invalid ${optionName} value: ${raw}`);
  }
  if (min != null && value < min) {
    throw new Error(`Invalid ${optionName} value: ${raw}`);
  }
  return value;
}

function readPositiveNumber(raw, optionName) {
  const value = readNumber(raw, optionName, 0);
  if (value <= 0) {
    throw new Error(`Invalid ${optionName} value: ${raw}`);
  }
  return value;
}

export function parseArgs(argv) {
  const args = {
    file: null,
    forbidSplitWords: new Set(),
    forceSplitWords: new Set(),
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];

    if (!arg.startsWith("-") && !args.file) {
      args.file = arg;
      continue;
    }

    if (arg === "--compact") {
      args.pretty = false;
      args.format = "compact";
      continue;
    }

    if (arg === "--pretty") {
      args.pretty = true;
      args.format = "pretty";
      continue;
    }

    if (arg === "--json") {
      args.json = true;
      continue;
    }

    if (arg === "--capturing") {
      args.groupStyle = "capturing";
      continue;
    }

    if (arg === "--noncapturing") {
      args.groupStyle = "noncapturing";
      continue;
    }

    if (arg === "--help" || arg === "-h") {
      printHelpAndExit(0);
    }

    const balancedOpt = readOptionValue(argv, i, "--balanced", {
      optional: true,
      defaultValue: "100",
    });
    if (balancedOpt) {
      args.pretty = true;
      args.format = "balanced";
      args.wrap = readPositiveNumber(balancedOpt.raw, "--balanced");
      i = balancedOpt.nextIndex;
      continue;
    }

    const indentOpt = readOptionValue(argv, i, "--indent");
    if (indentOpt) {
      const raw = indentOpt.raw;
      if (raw === "auto") {
        args.indent = "auto";
      } else {
        args.indent = readNumber(raw, "--indent", 0);
      }
      i = indentOpt.nextIndex;
      continue;
    }

    const wrapOpt = readOptionValue(argv, i, "--wrap");
    if (wrapOpt) {
      args.wrap = readPositiveNumber(wrapOpt.raw, "--wrap");
      i = wrapOpt.nextIndex;
      continue;
    }

    const minSplitOpt = readOptionValue(argv, i, "--min-word-split");
    if (minSplitOpt) {
      args.minWordSplitLen = readNumber(minSplitOpt.raw, "--min-word-split", 0);
      i = minSplitOpt.nextIndex;
      continue;
    }

    const noSplitOpt = readOptionValue(argv, i, "--no-split");
    if (noSplitOpt) {
      addCsvWordsToSet(args.forbidSplitWords, noSplitOpt.raw);
      i = noSplitOpt.nextIndex;
      continue;
    }

    const splitOpt = readOptionValue(argv, i, "--split");
    if (splitOpt) {
      addCsvWordsToSet(args.forceSplitWords, splitOpt.raw);
      i = splitOpt.nextIndex;
      continue;
    }

    throw new Error(`Unknown argument: ${arg}`);
  }

  return args;
}

export function printHelpAndExit(code = 0) {
  console.log(`
Usage:
  node regex-builder.mjs <input.txt> [options]

Options:
  --pretty                   Pretty multiline output (default)
  --compact                  Single-line compact regex
  --balanced[=N]             Balanced multiline output with inline-first wrapping (default wrap: 100)
  --json                     Print compressed trie as JSON instead of regex
  --capturing                Use (...) groups (default)
  --noncapturing             Use (?:...) groups
  --indent N|auto            Pretty-print indentation width, or continuation-column alignment (default: auto)
  --wrap N                   Maximum emitted line length in pretty/balanced mode (default: 100)
  --min-word-split N         Minimum chars in local split prefix before mid-word factoring (default: 3)
  --no-split W1[,...W2]      Forbid mid-word splitting before completing these fragments (exact, case-sensitive)
  --split W1[,...W2]         Allow exact split points even when min-word-split / no-split would block
  -h, --help                 Show this help

Input:
  Newline-separated strings. Leading "|" is allowed per line.
`);
  process.exit(code);
}
