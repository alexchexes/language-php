# SYNTAX TEST "source.php" "regex explicit host quote parity"
<?php

// REGEX heredoc body quote escapes

// Extracted from: should tokenize raw and decoded apostrophe escapes in REGEX heredoc
<<<REGEX
  /\'/
#  ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize raw and decoded apostrophe escapes in REGEX heredoc
<<<REGEX
  /\\'/
#  ^^ string.regexp.heredoc.php constant.character.escape.php
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize decoded double-quote escapes in REGEX heredoc
<<<REGEX
  /\\"/
#  ^^ string.regexp.heredoc.php constant.character.escape.php
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// REGEXP nowdoc body quote escapes

// Extracted from: should tokenize raw apostrophe escapes in REGEXP nowdoc
<<<'REGEXP'
  /\'/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize raw double-quote escapes in REGEXP nowdoc
<<<'REGEXP'
  /\"/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// REGEX heredoc character-class quote parity

// Extracted from: should tokenize decoded apostrophe escapes in REGEX heredoc character classes
<<<REGEX
  /[\\'a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^ ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
REGEX;

// Extracted from: should tokenize decoded double-quote escapes in REGEX heredoc character classes
<<<REGEX
  /[\\"a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^ ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
REGEX;

// Extracted from: should decompose repeated interpreted backslashes before quotes in REGEX heredoc character classes
<<<REGEX
  /[\\\\'a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should decompose repeated interpreted backslashes before quotes in REGEX heredoc character classes
<<<REGEX
  /[\\\\\"a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should keep longer quote parity consistent in REGEX heredoc character classes
<<<REGEX
  /[\\\\\\'a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^^^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#         ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should keep longer quote parity consistent in REGEX heredoc character classes
<<<REGEX
  /[\\\\\\\"a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^^  ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
REGEX;

// REGEXP nowdoc character-class quote parity

// Extracted from: should tokenize quote parity in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\'a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEXP;

// Extracted from: should tokenize quote parity in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\"a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
REGEXP;

// Extracted from: should tokenize quote parity in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\"a-z]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;

// Extracted from: should keep longer quote parity consistent in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\\\\'a-z]/
#   ^^^^^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#         ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;

// Extracted from: should keep longer quote parity consistent in REGEXP nowdoc character classes
<<<'REGEXP'
  /[\\\\\\\"a-z]/
#   ^^^^^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#         ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEXP;
