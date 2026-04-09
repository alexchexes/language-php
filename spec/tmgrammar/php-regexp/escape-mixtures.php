# SYNTAX TEST "source.php" "regex escape mixtures"
<?php

// Raw class escape mixtures

// Extracted from: should keep valid raw class escapes, stray \E, short \x, and invalid ones distinct in quoted regex character classes
 "/[\c; \E \pL \PL \D \H \V \W \x \L \z \A]/";
#   ^^^ ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^^^ ^^^ ^^ ^^ ^^ ^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                              ^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                                 ^^ ^^ ^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid raw class escapes, stray \E, short \x, and invalid ones distinct in quoted regex character classes
 '/[\c; \E \pL \PL \D \H \V \W \x \L \z \A]/';
#   ^^^ ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^^^ ^^^ ^^ ^^ ^^ ^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                              ^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                                 ^^ ^^ ^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid raw class escapes, stray \E, short \x, and invalid ones distinct in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\c; \E \pL \PL \D \H \V \W \x \L \z \A]/
#   ^^^ ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^^^ ^^^ ^^ ^^ ^^ ^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                              ^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                                 ^^ ^^ ^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
REGEXP;

// Decoded class escape mixtures

// Extracted from: should keep valid decoded class escapes, stray \\E, and invalid ones distinct in quoted regex character classes
 "/[\\c; \\E \\pL \\PL \\D \\H \\V \\W \\x \\L \\z \\A]/";
#   ^^   ^^ constant.character.escape.php constant.character.escape.regexp.php
#     ^^   ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#            ^^   ^^   ^^  ^^  ^^  ^^  constant.character.escape.php constant.character.class.regexp.php
#              ^^   ^^   ^   ^   ^   ^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                                      ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                                        ^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                                          ^^  ^^  ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                                            ^   ^   ^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid decoded class escapes, stray \\E, and invalid ones distinct in quoted regex character classes
 '/[\\c; \\E \\pL \\PL \\D \\H \\V \\W \\x \\L \\z \\A]/';
#   ^^   ^^  constant.character.escape.php constant.character.escape.regexp.php
#     ^^   ^  constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#            ^^   ^^   ^^  ^^  ^^  ^^ constant.character.escape.php constant.character.class.regexp.php
#              ^^   ^^   ^   ^   ^   ^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                                      ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                                        ^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                                          ^^  ^^  ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                                            ^   ^   ^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid decoded class escapes, stray \\E, and invalid ones distinct in REGEXP heredoc character classes
<<<REGEXP
  /[\\c; \\E \\pL \\PL \\D \\H \\V \\W \\x \\L \\z \\A]/
#   ^^   ^^  constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#     ^^   ^  constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#            ^^   ^^   ^^  ^^  ^^  ^^ constant.other.character-class.set.regexp.php
#            ^^   ^^   ^^  ^^  ^^  ^^ constant.character.escape.php constant.character.class.regexp.php
#              ^^   ^^   ^   ^   ^   ^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                                      ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                                        ^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                                          ^^  ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php invalid.illegal.escape.regexp.php
#                                            ^   ^   ^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
REGEXP;

// Interpreted-host class overlaps and PHP-first escapes

// Extracted from: should keep PHP string escapes inside double quoted regex character classes
 "/[\x01-\x09 \n \r \$]/";
#  ^                  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^ ^^^^ constant.character.escape.hex.php
#       ^ keyword.operator.range.regexp.php
#             ^^ ^^ ^^ constant.character.escape.php

// Single-backslash overlapping escapes PHP-first in double quoted regex character classes
 "/[\1 \x41 \n \v]/";
#  ^             ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.octal.php
#      ^^^^ constant.character.escape.hex.php
#           ^^ ^^ constant.character.escape.php

 "/[\$ \u{41} \d \x{41}]/";
#  ^                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php
#      ^^^^^^ constant.character.escape.unicode.php
#             ^^ constant.character.class.regexp.php
#                ^^^^^^ constant.character.numeric.regexp.php

// Decoded overlapping escapes in double quoted regex character classes
 "/[\\1 \\x41 \\n \\v]/";
#  ^                 ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php constant.numeric.octal.regexp.php
#     ^ constant.numeric.octal.regexp.php
#       ^^ constant.character.escape.php constant.character.numeric.regexp.php
#         ^^^ constant.character.numeric.regexp.php
#             ^^ constant.character.escape.php constant.character.escape.regexp.php
#               ^ constant.character.escape.regexp.php
#                 ^^ constant.character.escape.php constant.character.class.regexp.php
#                   ^ constant.character.class.regexp.php

 "/[\\$ \\u{41} \\d \\x{41}]/";
#  ^                       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php constant.character.escape.regexp.php
#     ^ constant.character.escape.regexp.php
#       ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#         ^ invalid.illegal.escape.regexp.php
#           ^^ constant.numeric.regexp.php
#               ^^ constant.character.escape.php constant.character.class.regexp.php
#                 ^ constant.character.class.regexp.php
#                   ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                     ^^^^^ constant.character.numeric.regexp.php

// Decoded overlapping escapes in single quoted regex character classes
 '/[\\1 \\x41 \\n \\v]/';
#  ^                 ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php constant.numeric.octal.regexp.php
#     ^ constant.numeric.octal.regexp.php
#       ^^ constant.character.escape.php constant.character.numeric.regexp.php
#         ^^^ constant.character.numeric.regexp.php
#             ^^ constant.character.escape.php constant.character.escape.regexp.php
#               ^ constant.character.escape.regexp.php
#                 ^^ constant.character.escape.php constant.character.class.regexp.php
#                   ^ constant.character.class.regexp.php

 '/[\\$ \\u{41} \\d \\x{41}]/';
#  ^                       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php constant.character.escape.regexp.php
#     ^ constant.character.escape.regexp.php
#       ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#         ^ invalid.illegal.escape.regexp.php
#           ^^ constant.numeric.regexp.php
#               ^^ constant.character.escape.php constant.character.class.regexp.php
#                 ^ constant.character.class.regexp.php
#                   ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                     ^^^^^ constant.character.numeric.regexp.php

// Extracted from: should keep transported PHP code-point escapes PHP-first in double quoted regex character classes
 "/[\\\x21 \\\u{21}]/";
#  ^               ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^     ^^ constant.character.escape.php
#     ^^^^ constant.character.escape.hex.php
#            ^^^^^^ constant.character.escape.unicode.php

// Extracted from: should keep single-backslash overlapping escapes PHP-first in REGEXP heredoc character classes
<<<REGEXP
  /[\1 \x41 \n \v]/
#  ^             ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.octal.php
#      ^^^^ constant.character.escape.hex.php
#           ^^ ^^ constant.character.escape.php
  /[\$ \u{41} \d \x{41}]/
#  ^                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php
#      ^^^^^^ constant.character.escape.unicode.php
#             ^^ constant.character.class.regexp.php
#                ^^^^^^ constant.character.numeric.regexp.php
REGEXP;

// Extracted from: should keep transported PHP code-point escapes PHP-first in REGEXP heredoc character classes
<<<REGEXP
  /[\\\x21 \\\u{21}]/
#  ^               ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^     ^^ constant.character.escape.php
#     ^^^^ constant.character.escape.hex.php
#            ^^^^^^ constant.character.escape.unicode.php
REGEXP;

// Decoded overlapping escapes in REGEXP heredoc character classes
<<<REGEXP
  /[\\1 \\x41 \\n \\v]/
#  ^                 ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php constant.numeric.octal.regexp.php
#     ^ constant.numeric.octal.regexp.php
#       ^^ constant.character.escape.php constant.character.numeric.regexp.php
#         ^^^ constant.character.numeric.regexp.php
#             ^^ constant.character.escape.php constant.character.escape.regexp.php
#               ^ constant.character.escape.regexp.php
#                 ^^ constant.character.escape.php constant.character.class.regexp.php
#                   ^ constant.character.class.regexp.php
  /[\\$ \\u{41} \\d \\x{41}]/
#  ^                       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^ constant.character.escape.php constant.character.escape.regexp.php
#     ^ constant.character.escape.regexp.php
#       ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#         ^ invalid.illegal.escape.regexp.php
#           ^^ constant.numeric.regexp.php
#               ^^ constant.character.escape.php constant.character.class.regexp.php
#                 ^ constant.character.class.regexp.php
#                   ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                     ^^^^^ constant.character.numeric.regexp.php
REGEXP;

// Raw body escape mixtures

// Extracted from: should keep valid raw body escapes, stray \E, and invalid ones distinct in quoted regexes
 "/\c; \E \pL \x \L \g \k \o \p \u \z \A \B \G/";
#  ^^^ ^^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#         ^^^ string.regexp.double-quoted.php constant.character.class.regexp.php
#             ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php
#                ^^ ^^ ^^ ^^ ^^ ^^  string.regexp.double-quoted.php invalid.illegal.escape.regexp.php
#                                  ^^ ^^ ^^ ^^ string.regexp.double-quoted.php keyword.control.anchor.regexp.php

// Extracted from: should keep valid raw body escapes, stray \E, and invalid ones distinct in quoted regexes
 '/\c; \E \pL \x \L \g \k \o \p \u \z \A \B \G/';
#  ^^^ ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#         ^^^ string.regexp.single-quoted.php constant.character.class.regexp.php
#             ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#                ^^ ^^ ^^ ^^ ^^ ^^ string.regexp.single-quoted.php invalid.illegal.escape.regexp.php
#                                  ^^ ^^ ^^ ^^ string.regexp.single-quoted.php keyword.control.anchor.regexp.php

// Extracted from: should keep valid raw body escapes, short \x, stray \E, and invalid ones distinct in REGEXP nowdoc
<<<'REGEXP'
  /\c; \E \pL \x \L \g \k \o \p \u \z \A \B \G/
#  ^^^ ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#         ^^^ string.regexp.nowdoc.php constant.character.class.regexp.php
#             ^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
#                ^^ ^^ ^^ ^^ ^^ ^^ string.regexp.nowdoc.php invalid.illegal.escape.regexp.php
#                                  ^^ ^^ ^^ ^^ string.regexp.nowdoc.php keyword.control.anchor.regexp.php
REGEXP;

// Decoded body escape mixtures

// Extracted from: should keep valid decoded body escapes, stray \\E, and invalid ones distinct in quoted regexes
 "/\\c; \\E \\pL \\x \\L \\g \\k \\o \\p \\u/";
#  ^^ constant.character.escape.php constant.character.escape.regexp.php
#    ^^   ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#       ^^ string.regexp.double-quoted.php constant.character.escape.php
#           ^^ constant.character.escape.php constant.character.class.regexp.php
#             ^^ string.regexp.double-quoted.php constant.character.class.regexp.php
#                ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                  ^ string.regexp.double-quoted.php constant.character.numeric.regexp.php
#                    ^^  ^^  ^^  ^^  ^^  ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                      ^   ^   ^   ^   ^   ^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid decoded body escapes, stray \\E, and invalid ones distinct in quoted regexes
 '/\\c; \\E \\pL \\x \\L \\g \\k \\o \\p \\u/';
#  ^^ constant.character.escape.php constant.character.escape.regexp.php
#    ^^   ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#       ^^ string.regexp.single-quoted.php constant.character.escape.php
#           ^^ constant.character.escape.php constant.character.class.regexp.php
#             ^^ string.regexp.single-quoted.php constant.character.class.regexp.php
#                ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                  ^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#                    ^^  ^^  ^^  ^^  ^^  ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                      ^   ^   ^   ^   ^   ^ string.regexp.single-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid decoded body escapes, stray \\E, and invalid ones distinct in REGEX heredoc
<<<REGEX
  /\\c; \\E \\pL \\x \\L \\g \\k \\o \\p \\u/
#  ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^   ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#       ^^ string.regexp.heredoc.php constant.character.escape.php
#           ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
#             ^^ string.regexp.heredoc.php constant.character.class.regexp.php
#                ^^ constant.character.escape.php constant.character.numeric.regexp.php
#                  ^ string.regexp.heredoc.php constant.character.numeric.regexp.php
#                    ^^  ^^  ^^  ^^  ^^  ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                      ^   ^   ^   ^   ^   ^ string.regexp.heredoc.php invalid.illegal.escape.regexp.php
REGEX;
