# VS Code Preview Extension

Local-only extension scaffold for previewing grammar changes.

## What It Does

Generates and contributes full `source.php` and `text.html.php` grammars from this repo's `grammars/php.cson` and `grammars/html.cson`.

## Commands (from repo root)

- `pnpm run preview:sync` - Generate *.tmLanguage.json grammar files from *.cson grammar files
- `pnpm run preview:host` - Supposed to launch VS Code Extension Host but doesn't work
- `pnpm run preview:vsix` - Runs preview:sync, then packages the extension into `language-php-preview.vsix`
- `pnpm run preview:install` - Installs the packaged extension to actual VS Code.

## Workflow

2. Run `pnpm test`.
4. Run `pnpm run preview:vsix`.
5. Run `pnpm run preview:install` or add the `language-php-preview.vsix` manually via `Extensions: Install from VSIX...` command in VS Code.
6. Enable or disable the installed preview extension in your regular VS Code.
