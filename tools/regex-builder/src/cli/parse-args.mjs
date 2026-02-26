function addCsvWordsToSet(set, raw) {
  if (raw == null) return;

  for (const part of String(raw).split(",")) {
    const word = part.trim();
    if (!word) continue;
    set.add(word);
  }
}

export function parseArgs(argv) {
  const args = {
    file: null,
    pretty: true,
    json: false,
    groupStyle: "capturing",
    indent: "auto",
    wrap: 100,
    minWordSplitLen: 3,
    forbidSplitWords: new Set(),
    enableSuffixGrouping: true,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];

    if (!arg.startsWith("-") && !args.file) {
      args.file = arg;
      continue;
    }

    if (arg === "--compact") args.pretty = false;
    else if (arg === "--pretty") args.pretty = true;
    else if (arg === "--json") args.json = true;
    else if (arg === "--capturing") args.groupStyle = "capturing";
    else if (arg === "--noncapturing") args.groupStyle = "noncapturing";
    else if (arg === "--no-prefix-grouping") args.enableSuffixGrouping = false;
    else if (arg === "--indent") {
      const raw = argv[++i];
      if (raw == null) throw new Error("Missing value for --indent");

      if (raw === "auto") {
        args.indent = "auto";
      } else {
        const value = Number(raw);
        if (!Number.isFinite(value) || value < 0) {
          throw new Error(`Invalid --indent value: ${raw}`);
        }
        args.indent = value;
      }
    } else if (arg === "--help" || arg === "-h") {
      printHelpAndExit(0);
    } else if (arg === "--wrap") {
      const value = Number(argv[++i]);
      if (!Number.isFinite(value) || value <= 0) {
        throw new Error(`Invalid --wrap value: ${value}`);
      }
      args.wrap = value;
    } else if (arg === "--min-word-split") {
      const value = Number(argv[++i]);
      if (!Number.isFinite(value) || value < 0) {
        throw new Error(`Invalid --min-word-split value: ${value}`);
      }
      args.minWordSplitLen = value;
    } else if (arg === "--no-split" || arg.startsWith("--no-split=")) {
      const raw =
        arg === "--no-split" ? argv[++i] : arg.slice("--no-split=".length);

      if (raw == null) throw new Error("Missing value for --no-split");
      addCsvWordsToSet(args.forbidSplitWords, raw);
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
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
  --json                     Print compressed trie as JSON instead of regex
  --capturing                Use (...) groups (default)
  --noncapturing             Use (?:...) groups
  --no-prefix-grouping       Disable suffix regrouping pass
  --indent N|auto            Pretty-print indentation width, or continuation-column alignment (default: auto)
  --wrap N                   Maximum emitted line length in pretty mode (default: 100)
  --min-word-split N         Minimum chars in local split prefix before mid-word factoring (default: 3)
  --no-split W1[,...W2]      Forbid mid-word splitting before completing these fragments (exact, case-sensitive)
  -h, --help                 Show this help

Input:
  Newline-separated strings. Leading "|" is allowed per line.
`);
  process.exit(code);
}
