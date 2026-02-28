This contains lists of known identifiers used by snapshot tests:

* `./constants.properties`: known constants
* `./functions.properties`: known functions

The test definitions live in `spec/symbol-snapshots-spec.coffee` (`TARGET_DEFS`).
Each target config stays minimal:

* `name`
* `sourceFormatFn`
* `expectedScope` (RegExp)

`listPath` and `snapshotPath` are derived by harness helpers from `name`:

* list file: `{name}.properties`
* snapshot file: `{name}.snapshot.json`

Generated near-miss identifiers are also checked against the same `expectedScope` rule.
List files accept one identifier per line and allow comment lines starting with `#` or `!`.

To add a new identifier: add it to `php.cson`, then add it to `constants.properties` or `functions.properties`.

To refresh snapshots after changes:

```sh
UPDATE_SNAPSHOTS=1 yarn test
```
