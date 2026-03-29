# SYNTAX TEST "source.php" "regex character-class quoted literals"
<?php

// Quoted wrappers

// Extracted from: should tokenize quoted literals inside quoted regex character classes
 "/[\Q[\"]\Ea]/";
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#      ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php
#         ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php

// Extracted from: should tokenize quoted literals inside quoted regex character classes
 '/[\Q[\']\Ea]/';
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#      ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php
#         ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php

// Extracted from: should keep operator-looking punctuation literal inside quoted regex character-class quoted literals
 "/[\Q.?+*^$|()[]\E]/";
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php
#                ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

// Extracted from: should keep operator-looking punctuation literal inside quoted regex character-class quoted literals
 '/[\Q.?+*^$|()[]\E]/';
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php
#                ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

// Extracted from: should tokenize decoded and asymmetric quoted-literal boundaries in quoted regex character classes
 "/[\\Q[\"]\Ea]/";
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#      ^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#       ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php
#          ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

// Extracted from: should tokenize decoded and asymmetric quoted-literal boundaries in quoted regex character classes
 "/[\Q[\"]\\Ea]/";
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#      ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php
#         ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#           ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

// Extracted from: should tokenize decoded and asymmetric quoted-literal boundaries in quoted regex character classes
 '/[\\Q[\']\Ea]/';
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#      ^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#       ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php
#          ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

// Extracted from: should tokenize decoded and asymmetric quoted-literal boundaries in quoted regex character classes
 '/[\Q[\']\\Ea]/';
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#      ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php
#         ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#           ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

// Explicit hosts

// Extracted from: should tokenize quoted literals inside REGEXP heredoc character classes
<<<REGEXP
  /[\Q[']\Ea]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#        ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;

// Extracted from: should tokenize quoted literals inside REGEXP heredoc character classes
<<<REGEXP
  /[\\Q[']\\Ea]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#      ^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#         ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#           ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize quoted literals inside REGEXP heredoc character classes
<<<REGEXP
  /[\\Q[']\Ea]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#      ^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#         ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize quoted literals inside REGEXP heredoc character classes
<<<REGEXP
  /[\Q[']\\Ea]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#        ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should keep operator-looking punctuation literal inside REGEXP heredoc character-class quoted literals
<<<REGEXP
  /[\Q.?+*^$|()[]\E]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^^^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php
#                ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize quoted literals inside REGEXP nowdoc character classes
<<<'REGEXP'
  /[\Q[]\Ea]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#       ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#         ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;

// Extracted from: should tokenize quoted literals inside REGEXP nowdoc character classes
<<<'REGEXP'
  /[\Q[']\Ea]/
#   ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php - punctuation.definition.character-class.regexp.php
#        ^^ meta.embedded.character-class.regexp.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;
