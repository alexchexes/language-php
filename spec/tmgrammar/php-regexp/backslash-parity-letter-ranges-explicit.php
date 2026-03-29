# SYNTAX TEST "source.php" "regex explicit character-class backslash parity before letter ranges"
<?php

// REGEX heredoc

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in REGEX heredoc character classes
<<<REGEX
  /[\a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php keyword.operator.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should keep interpreted backslash parity consistent before letter ranges in REGEX heredoc character classes
<<<REGEX
  /[\\a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should keep interpreted escaped backslashes separate from following letter ranges in REGEX heredoc character classes
<<<REGEX
  /[\\\a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^ ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
REGEX;

// REGEXP nowdoc

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php keyword.operator.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
REGEXP;

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\a-z]/
#   ^^^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php keyword.operator.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;

// Extracted from: should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\\a-z]/
#   ^^^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#        ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
REGEXP;
