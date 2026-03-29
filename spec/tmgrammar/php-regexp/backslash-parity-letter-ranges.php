# SYNTAX TEST "source.php" "regex character-class backslash parity before letter ranges"
<?php

// One backslash before letter ranges

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in quoted regex character classes
 "/[\a-z]/";
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^ string.regexp.character-class.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in quoted regex character classes
 '/[\a-z]/';
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^ string.regexp.character-class.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in REGEX heredoc character classes
<<<REGEX
  /[\a-z]/
#   ^^ string.regexp.character-class.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEX;

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\a-z]/
#   ^^ string.regexp.character-class.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEXP;

// Two backslashes before letter ranges

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in quoted regex character classes
 "/[\\a-z]/";
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in quoted regex character classes
 '/[\\a-z]/';
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in REGEX heredoc character classes
<<<REGEX
  /[\\a-z]/
#   ^^ string.regexp.character-class.php constant.character.escape.php
#     ^ string.regexp.character-class.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEX;

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\a-z]/
#   ^^ string.regexp.character-class.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEXP;

// Three backslashes before letter ranges

// Extracted from: should keep interpreted escaped backslashes separate from following letter ranges in quoted regex character classes
 "/[\\\a-z]/";
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^ string.regexp.character-class.php constant.character.escape.php
#     ^ string.regexp.character-class.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php

// Extracted from: should keep interpreted escaped backslashes separate from following letter ranges in quoted regex character classes
 '/[\\\a-z]/';
#  ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^ string.regexp.character-class.php constant.character.escape.php
#     ^ string.regexp.character-class.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php

// Extracted from: should keep interpreted escaped backslashes separate from following letter ranges in REGEX heredoc character classes
<<<REGEX
  /[\\\a-z]/
#   ^^ string.regexp.character-class.php constant.character.escape.php
#     ^ string.regexp.character-class.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEX;

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\a-z]/
#   ^^^^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEXP;

// Four backslashes before letter ranges

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\\a-z]/
#   ^^^^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#         ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEXP;
