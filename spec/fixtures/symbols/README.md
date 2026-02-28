# Built-in Symbol Fixtures

This contains lists of known identifiers used by snapshot tests:

* `constants.txt`: known constants
* `functions.txt`: known functions

To add a new identifier: add it to `php.cson`, then add it to `constants.txt` or `functions.txt`.

To refresh snapshots after changes:

```sh
UPDATE_SNAPSHOTS=1 yarn test
```
