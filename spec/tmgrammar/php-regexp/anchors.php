# SYNTAX TEST "source.php" "regex anchors"
<?php

// Extracted from: should keep anchors distinct from fallback operator chars in quoted regexes
 '/^a$+*/';
#  ^ ^ string.regexp.single-quoted.php keyword.control.anchor.regexp.php
#     ^^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php

// Extracted from: should keep anchors distinct from fallback operator chars in quoted regexes
 "/^a$+*/";
#  ^ ^ string.regexp.double-quoted.php keyword.control.anchor.regexp.php
#     ^^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php

// Extracted from: should keep anchors distinct from fallback operator chars in REGEX heredoc
<<<REGEX
  /^a$+*/
#  ^ ^ string.regexp.heredoc.php keyword.control.anchor.regexp.php
#     ^^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
REGEX;

// Extracted from: should keep anchors distinct from fallback operator chars in REGEXP nowdoc
<<<'REGEXP'
  /^a$+*/
#  ^ ^ string.regexp.nowdoc.php keyword.control.anchor.regexp.php
#     ^^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
REGEXP;

// Extracted from: should keep escaped dots and anchors distinct after interpreted backslash transport in double quoted regexes
 "/\\.$/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^ string.regexp.double-quoted.php keyword.control.anchor.regexp.php

// Extracted from: should tokenize decoded anchors and short hex escapes in quoted regexes
 "/\\b\\x\\z/";
#  ^^    ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.control.anchor.regexp.php
#    ^     ^ string.regexp.double-quoted.php keyword.control.anchor.regexp.php
#     ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#       ^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded anchors and short hex escapes in quoted regexes
 '/\\A\\B\\G\\Z\\x/';
#  ^^ ^^ ^^ ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.control.anchor.regexp.php
#    ^  ^  ^  ^ string.regexp.single-quoted.php keyword.control.anchor.regexp.php
#              ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#                ^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded anchors and short hex escapes in REGEX heredoc
<<<REGEX
 /\\b\\x\\z/
# ^^    ^^ string.regexp.heredoc.php constant.character.escape.php keyword.control.anchor.regexp.php
#   ^     ^ string.regexp.heredoc.php keyword.control.anchor.regexp.php
#    ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#      ^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Extracted from: should tokenize the full decoded anchor surface in REGEX heredoc
<<<REGEX
 /\\b\\B\\A\\Z\\z\\G/
# ^^ ^^ ^^ ^^ ^^ ^^ string.regexp.heredoc.php constant.character.escape.php keyword.control.anchor.regexp.php
#   ^  ^  ^  ^  ^  ^ string.regexp.heredoc.php keyword.control.anchor.regexp.php
REGEX;

// Extracted from: should tokenize the full raw anchor surface in REGEXP nowdoc
<<<'REGEXP'
  /\b\B\A\Z\z\G^$/
#  ^^^^^^^^^^^^^^ string.regexp.nowdoc.php keyword.control.anchor.regexp.php
REGEXP;
