# VS Code Preview Extension

Local-only extension scaffold for previewing grammar changes before upstream PRs are accepted.

## What It Does

- Generates and contributes full `source.php` and `text.html.php` grammars from this repo's `grammars/php.cson` and `grammars/html.cson`.
- Keeps the VS Code language id as `php`, so `onLanguage:php` extensions (for example Intelephense) still activate.
- Changes TextMate tokenization/scopes only; this is intended for local preview before upstream merges.

## Commands (from repo root)

- `pnpm run preview:sync`
- `pnpm run preview:host`
- `pnpm run preview:vsix`
- `pnpm run preview:install`

## Workflow

1. Merge grammar feature branches into `local/preview-vsix`.
2. Run `pnpm test`.
3. Run `pnpm run preview:sync`.
4. Run `pnpm run preview:vsix`.
5. Run `pnpm run preview:install`.
6. Enable or disable the installed preview extension in your regular VS Code profile.
