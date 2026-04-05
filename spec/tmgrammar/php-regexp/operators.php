# SYNTAX TEST "source.php" "regex operators"
<?php

// Extracted from: should keep escaped alternation and quantifiers distinct from real operators in quoted regexes
// Escaped operator-looking chars stay escapes; later raw ones stay real operators.
 '/\|\?\+\*a?b+c*/';
#  ^^^^^^^^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#           ^ ^ ^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php

// Extracted from: should keep escaped alternation and quantifiers distinct from real operators in quoted regexes
 "/\|\?\+\*a?b+c*/";
#  ^^^^^^^^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#           ^ ^ ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php

// Extracted from: should keep escaped alternation and quantifiers distinct from real operators in REGEX heredoc
<<<REGEX
  /\|\?\+\*a?b+c*/
#  ^^^^^^^^ string.regexp.heredoc.php constant.character.escape.regexp.php
#           ^ ^ ^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
REGEX;

// Extracted from: should keep escaped alternation and quantifiers distinct from real operators in REGEXP nowdoc
<<<'REGEXP'
  /\|\?\+\*a?b+c*/
#  ^^^^^^^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#           ^ ^ ^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
REGEXP;

// Extracted from: should tokenize supported non-state-changing operator escapes in quoted regexes from fixtures
"/\.\*\+\?\^\|/";
# ^^^^^^^^^^^^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported non-state-changing operator escapes in quoted regexes from fixtures
'/\.\*\+\?\^\|/';
# ^^^^^^^^^^^^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Added to keep the operator-escape family aligned across hosts.
<<<REGEX
 /\.\*\+\?\^\|/
# ^^^^^^^^^^^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Added to keep the operator-escape family aligned across hosts.
<<<'REGEXP'
 /\.\*\+\?\^\|/
# ^^^^^^^^^^^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Additional tmgrammar coverage: one-more-backslash transport spot checks.

 "/\\\|/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^ string.regexp.double-quoted.php keyword.operator.or.regexp.php

 "/\\\\|/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php
#    ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#      ^ string.regexp.double-quoted.php keyword.operator.or.regexp.php

 '/\\\|/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#     ^ string.regexp.single-quoted.php keyword.operator.or.regexp.php

 '/\\\\|/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php
#    ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#      ^ string.regexp.single-quoted.php keyword.operator.or.regexp.php

<<<REGEX
 /\\\|/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#    ^ string.regexp.heredoc.php keyword.operator.or.regexp.php
REGEX;

<<<REGEX
 /\\\\|/
# ^^ string.regexp.heredoc.php constant.character.escape.php
#   ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.heredoc.php keyword.operator.or.regexp.php
REGEX;

<<<'REGEXP'
 /\\|/
# ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#   ^ string.regexp.nowdoc.php keyword.operator.or.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw structural-escape surface in REGEXP nowdoc
<<<'REGEXP'
  /\.\$\^/
#  ^^^^^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;
