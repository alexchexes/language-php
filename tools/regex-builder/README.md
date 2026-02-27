# Regex Builder

## Purpose
This tool builds grouped regex alternations from newline-separated identifiers.

It is intended to make large `support`-scope regexes in [`php.cson`](../../grammars/php.cson#L1443) more maintainable by replacing hard-to-edit blocks of deeply nested alternations with more readable, pretty-printed output.

Use it for constants, functions, class names, or any other identifier set.

## Quick start

```bash
pnpm regex-builder <input-file>
# or yarn regex-builder ...
# or npm run -s regex-builder ...
```

`<input-file>` can be any text file containing identifiers, one per line, for which you need a matching regex, without any additional characters.

Run it with the [example file](./example-input.txt):
```sh
pnpm regex-builder tools/regex-builder/example-input.txt
```

Or write the output to a `.re` file:

```bash
pnpm regex-builder tools/regex-builder/example-input.txt > example-output.re
```

Then you can inspect or edit the output in an editor with dedicated regex syntax support for convenience (VS Code, unfortunately, doesn't have regex language mode).

## Options
- `--compact`: don't prettify, print on one-line
- `--balanced[=N]` / `--balanced N`: in-between format that keeps groups inline until wrap limit (default `100`)
- `--json`: print compressed trie JSON
- `--capturing` / `--noncapturing`: group style
- `--indent N|auto`: pretty/balanced indentation mode
- `--wrap N` / `--wrap=N`: max pretty line length (default: `100`)
- `--min-word-split N`: minimum chars before mid-word factoring. Default `3`.
- `--no-split W1[,...W2]` / `--no-split=W1[,...W2]`: comma-separated list of words that should not be factored (example: use `--no-split STANDARD` to avoid `STA(NDARD|TUS)` instead of `STANDARD|STATUS`)
- `--split W1[,...W2]` / `--split=W1[,...W2]`: comma-separated list of exact split fragments to allow even when `--min-word-split` / `--no-split` would block (`--split` wins on conflicts)

## Testing
Run fixture tests:

```bash
npm run -s test:regex-builder
```

Update fixture expected outputs, then run tests:

```bash
npm run -s test:regex-builder:update
```

Each fixture directory uses these file names:

- `input.txt` (required): input identifiers
- `args.txt` (optional): extra CLI args, one arg per line, `#` comments allowed
- `expected.re` (required in test mode): expected pretty output
- `expected-compact.re` (required in test mode): expected compact output
- `positive.txt` (optional): explicit positives; if omitted, `input.txt` values are used
- `negative.txt` (required): values that must not match

Regex semantic assertions are evaluated with boundary usage:

```txt
\b(?:FOO)\b
```

---

Regex that may help find undesired word splits:
```
([^_() |]\(|\)[a-z])
```

Regex to find incorrectly placed alternation operators
```
(\(\s*\||\|\s*\))
```
