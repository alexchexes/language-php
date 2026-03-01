This contains input files with lists of names used for testing rules with long enumerations of known language symbols.

- `./functions.properties`: known functions (target scope `/^support\.function\..+\.php$/`)
- `./constants.properties`: known constants (target scope `/^support\.constant\..+\.php$/`)

In these files there should be one identifier per line without any extra characters except comments that start with either `#`, `;` or `!`.

> `.properties` format is handy as code editors allow toggle and highlight comments in it. It is a non-standardized format, though editors may treat it similar to .ini.

- Any identifier that is added to one of the input files, but is not covered by any rule of the target scope, will effectively fail the spec test.
- The "vice-versa" also works although heuristically. Test fails if there is a regex containing parts that are never found in the corresponding scope (for each target, defined in spec).
  Example:
  If there is a rule with regex `msg_((get|remove|set|stat)_queue` that assigns scope `support.function.sem.php`
  And there is spec target `/^support\.function\..+\.php$/`,
  Then in the test target input file (`./functions.properties`) MUST be all of the following:

  - at least one identifier that contains `msg_`
  - at least one that contains `get`
  - at least one that contains `remove`
  - at least one that contains `set`
  - at least one that contains `stat`
  - at least one that contains `_queue`
    If that's not true, test fails.
    This effectively catches many typos including cases like extra `_` (`(_get)` instead of `(get)`) or `set_stat` instead of `set|stat`, but it does it bluntly and heuristically so it doesn't guarantee that regex is 100% correct — just helps with common typos/mistakes/non-existing identifiers.

---

To add a new identifier: add it to `php.cson`, then add it to `constants.properties` or `functions.properties`.

To refresh snapshots after changes:

```sh
UPDATE_SNAPSHOTS=1 yarn test
```
