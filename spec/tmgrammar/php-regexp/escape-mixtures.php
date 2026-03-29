# SYNTAX TEST "source.php" "regex escape mixtures"
<?php

// Raw class escape mixtures

// Extracted from: should keep valid raw class escapes, stray \E, short \x, and invalid ones distinct in quoted regex character classes
 "/[\c;\pL\PL\x\E\L\z\A\D\H\V\W]/";
#   ^^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^^^^^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#            ^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#              ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                ^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                      ^^^^^^^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php

// Extracted from: should keep valid raw class escapes, stray \E, short \x, and invalid ones distinct in quoted regex character classes
 '/[\c;\pL\PL\x\E\L\z\A\D\H\V\W]/';
#   ^^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^^^^^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#            ^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#              ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                ^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                      ^^^^^^^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php

// Extracted from: should keep valid raw class escapes, stray \E, short \x, and invalid ones distinct in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\c;\pL\PL\x\E\L\z\A\D\H\V\W]/
#   ^^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^^^^^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#            ^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#              ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                ^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                      ^^^^^^^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
REGEXP;

// Decoded class escape mixtures

// Extracted from: should keep valid decoded class escapes, stray \\E, and invalid ones distinct in quoted regex character classes
 "/[\\c;\\pL\\PL\\E\\L\\z\\A\\D\\H\\V\\W]/";
#   ^^ constant.character.escape.php constant.character.escape.regexp.php
#     ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#       ^^  ^^ constant.character.escape.php constant.character.class.regexp.php
#         ^^  ^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#               ^^ constant.character.escape.php constant.character.escape.regexp.php
#                 ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                  ^^ ^^ ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                    ^  ^  ^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                           ^^ ^^ ^^ ^^ constant.character.escape.php constant.character.class.regexp.php
#                             ^  ^  ^  ^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php

// Extracted from: should keep valid decoded class escapes, stray \\E, and invalid ones distinct in quoted regex character classes
 '/[\\c;\\pL\\PL\\E\\L\\z\\A\\D\\H\\V\\W]/';
#   ^^ constant.character.escape.php constant.character.escape.regexp.php
#     ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#       ^^  ^^ constant.character.escape.php constant.character.class.regexp.php
#         ^^  ^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#               ^^ constant.character.escape.php constant.character.escape.regexp.php
#                 ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                  ^^ ^^ ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#                    ^  ^  ^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                           ^^ ^^ ^^ ^^ constant.character.escape.php constant.character.class.regexp.php
#                             ^  ^  ^  ^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php

// Extracted from: should keep valid decoded class escapes, stray \\E, and invalid ones distinct in REGEXP heredoc character classes
<<<REGEXP
  /[\\c;\\pL\\PL\\E\\L\\z\\A\\D\\H\\V\\W]/
#   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#     ^^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#       ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.class.regexp.php
#         ^^  ^^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#               ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#                 ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                  ^^ ^^ ^^ constant.other.character-class.set.regexp.php constant.character.escape.php invalid.illegal.escape.regexp.php
#                    ^  ^  ^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                           ^^ ^^ ^^ ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.class.regexp.php
#                             ^  ^  ^  ^ constant.other.character-class.set.regexp.php constant.character.class.regexp.php
REGEXP;

// Raw body escape mixtures

// Extracted from: should keep valid raw body escapes, stray \E, and invalid ones distinct in quoted regexes
 "/\c;\pL\E\L\g\k\o\p\u\z\A\B\G/";
#  ^^^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^^^ string.regexp.double-quoted.php constant.character.class.regexp.php
#        ^^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#          ^^^^^^^^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php
#                      ^^^^^^^^ string.regexp.double-quoted.php keyword.control.anchor.regexp.php

// Extracted from: should keep valid raw body escapes, stray \E, and invalid ones distinct in quoted regexes
 '/\c;\pL\E\L\g\k\o\p\u\z\A\B\G/';
#  ^^^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#     ^^^ string.regexp.single-quoted.php constant.character.class.regexp.php
#        ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#          ^^^^^^^^^^^^ string.regexp.single-quoted.php invalid.illegal.escape.regexp.php
#                      ^^^^^^^^ string.regexp.single-quoted.php keyword.control.anchor.regexp.php

// Extracted from: should keep valid raw body escapes, short \x, stray \E, and invalid ones distinct in REGEXP nowdoc
<<<'REGEXP'
  /\c;\pL\x\E\L\g\k\o\p\u\z\A\B\G/
#  ^^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#     ^^^ string.regexp.nowdoc.php constant.character.class.regexp.php
#        ^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
#          ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#            ^^^^^^^^^^^^ string.regexp.nowdoc.php invalid.illegal.escape.regexp.php
#                        ^^^^^^^^ string.regexp.nowdoc.php keyword.control.anchor.regexp.php
REGEXP;

// Decoded body escape mixtures

// Extracted from: should keep valid decoded body escapes, stray \\E, and invalid ones distinct in quoted regexes
 "/\\c;\\pL\\E\\L\\g\\k\\o\\p\\u/";
#  ^^ constant.character.escape.php constant.character.escape.regexp.php
#    ^^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#      ^^ constant.character.escape.php constant.character.class.regexp.php
#        ^^ string.regexp.double-quoted.php constant.character.class.regexp.php
#          ^^ string.regexp.double-quoted.php constant.character.escape.php
#            ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#             ^^ ^^ ^^ ^^ ^^ ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#               ^  ^  ^  ^  ^  ^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid decoded body escapes, stray \\E, and invalid ones distinct in quoted regexes
 '/\\c;\\pL\\E\\L\\g\\k\\o\\p\\u/';
#  ^^ constant.character.escape.php constant.character.escape.regexp.php
#    ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#      ^^ constant.character.escape.php constant.character.class.regexp.php
#        ^^ string.regexp.single-quoted.php constant.character.class.regexp.php
#          ^^ string.regexp.single-quoted.php constant.character.escape.php
#            ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#             ^^ ^^ ^^ ^^ ^^ ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#               ^  ^  ^  ^  ^  ^ string.regexp.single-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: should keep valid decoded body escapes, stray \\E, and invalid ones distinct in REGEX heredoc
<<<REGEX
 /\\c;\\pL\\E\\L\\g\\k\\o\\p\\u/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
#     ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
#       ^^ string.regexp.heredoc.php constant.character.class.regexp.php
#         ^^ string.regexp.heredoc.php constant.character.escape.php
#           ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#            ^^ ^^ ^^ ^^ ^^ ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#              ^  ^  ^  ^  ^  ^ string.regexp.heredoc.php invalid.illegal.escape.regexp.php
REGEX;
