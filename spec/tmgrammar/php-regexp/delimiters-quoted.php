# SYNTAX TEST "source.php" "quoted regex delimiters"
<?php

// Extracted from: should tokenize single quoted string regex with escaped bracket
// Escaped bracket stays a regex escape in single-quoted wrappers.
 '/\[/';
#^ string.regexp.single-quoted.php punctuation.definition.string.begin.php
# ^ string.regexp.single-quoted.php punctuation.definition.string.begin.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#    ^ string.regexp.single-quoted.php punctuation.definition.string.end.regexp.php
#     ^ string.regexp.single-quoted.php punctuation.definition.string.end.php

// Extracted from: should tokenize quoted regex with slash inside character class
// Slash inside a class stays class content, not wrapper terminator.
 "/[a/b]/";
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#    ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - punctuation.definition.string.end.regexp.php punctuation.definition.string.end.php
#      ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#       ^ string.regexp.double-quoted.php punctuation.definition.string.end.regexp.php
#        ^ string.regexp.double-quoted.php punctuation.definition.string.end.php

// Extracted from: should tokenize trailing wrapper flags in quoted regexes
// Trailing wrapper flags remain modifier scopes.
 '/a/im';
#    ^^ string.regexp.single-quoted.php storage.modifier.regexp.php
#      ^ string.regexp.single-quoted.php punctuation.definition.string.end.php

// Extracted from: should tokenize trailing wrapper flags in quoted regexes
 "/a/im";
#    ^^ string.regexp.double-quoted.php storage.modifier.regexp.php
#      ^ string.regexp.double-quoted.php punctuation.definition.string.end.php

// Extracted from: should treat a leading closing bracket as literal class content in quoted regexes
// A leading ] inside a class stays literal, including after negation.
 "/[]a-z]/";
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - punctuation.definition.character-class.regexp.php
#       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

// Extracted from: should treat a leading closing bracket as literal class content in quoted regexes
 '/[^]a-z]/';
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^ meta.embedded.character-class.regexp.php keyword.operator.negation.regexp.php
#    ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - punctuation.definition.character-class.regexp.php
#        ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
