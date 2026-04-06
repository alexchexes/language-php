# SYNTAX TEST "source.php" "regex operators"
<?php

// Raw wildcard, alternation, and quantifiers.
'/a. b|c d? e+ f*/';
#  ^ string.regexp.single-quoted.php constant.character.class.wildcard.regexp.php
#     ^ string.regexp.single-quoted.php keyword.operator.or.regexp.php
#         ^  ^  ^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php

"/a. b|c d? e+ f*/";
#  ^ string.regexp.double-quoted.php constant.character.class.wildcard.regexp.php
#     ^ string.regexp.double-quoted.php keyword.operator.or.regexp.php
#         ^  ^  ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php

<<<REGEX
 /a. b|c d? e+ f*/
#  ^ string.regexp.heredoc.php constant.character.class.wildcard.regexp.php
#     ^ string.regexp.heredoc.php keyword.operator.or.regexp.php
#         ^  ^  ^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
REGEX;

<<<'REGEXP'
 /a. b|c d? e+ f*/
#  ^ string.regexp.nowdoc.php constant.character.class.wildcard.regexp.php
#     ^ string.regexp.nowdoc.php keyword.operator.or.regexp.php
#         ^  ^  ^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
REGEXP;

// Extracted from: should tokenize supported non-state-changing operator escapes in quoted regexes from fixtures
// Escaped wildcard, alternation, and quantifiers.
'/\. \| \? \+ \*/';
# ^^ ^^ ^^ ^^ ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php

"/\. \| \? \+ \*/";
# ^^ ^^ ^^ ^^ ^^ string.regexp.double-quoted.php constant.character.escape.regexp.php

<<<REGEX
 /\. \| \? \+ \*/
# ^^ ^^ ^^ ^^ ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

<<<'REGEXP'
 /\. \| \? \+ \*/
# ^^ ^^ ^^ ^^ ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Two source backslashes before escaped operators.
"/\\. \\| \\? \\+ \\*/";
# ^^  ^^  ^^  ^^  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#   ^   ^   ^   ^   ^ string.regexp.double-quoted.php constant.character.escape.regexp.php

'/\\. \\| \\? \\+ \\*/';
# ^^  ^^  ^^  ^^  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#   ^   ^   ^   ^   ^ string.regexp.single-quoted.php constant.character.escape.regexp.php

<<<REGEX
 /\\. \\| \\? \\+ \\*/
# ^^  ^^  ^^  ^^  ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^   ^   ^   ^   ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

<<<'REGEXP'
 /\\. \\| \\? \\+ \\*/
# ^^  ^^  ^^  ^^  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#   ^ string.regexp.nowdoc.php constant.character.class.wildcard.regexp.php
#       ^ string.regexp.nowdoc.php keyword.operator.or.regexp.php
#           ^   ^   ^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
REGEXP;

// Three source backslashes before escaped operators.
"/\\\. \\\| \\\? \\\+ \\\*/";
# ^^   ^^   ^^   ^^   ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#   ^    ^    ^    ^    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.class.wildcard.regexp.php
#         ^ string.regexp.double-quoted.php keyword.operator.or.regexp.php
#              ^    ^    ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php

'/\\\. \\\| \\\? \\\+ \\\*/';
# ^^   ^^   ^^   ^^   ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#   ^    ^    ^    ^    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#    ^ string.regexp.single-quoted.php constant.character.class.wildcard.regexp.php
#         ^ string.regexp.single-quoted.php keyword.operator.or.regexp.php
#              ^    ^    ^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php

<<<REGEX
 /\\\. \\\| \\\? \\\+ \\\*/
# ^^   ^^   ^^   ^^   ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^    ^    ^    ^    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#    ^ string.regexp.heredoc.php constant.character.class.wildcard.regexp.php
#         ^ string.regexp.heredoc.php keyword.operator.or.regexp.php
#              ^    ^    ^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
REGEX;

<<<'REGEXP'
 /\\\. \\\| \\\? \\\+ \\\*/
# ^^^^ ^^^^ ^^^^ ^^^^ ^^^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Four source backslashes before escaped operators.
"/\\\\. \\\\| \\\\? \\\\+ \\\\*/";
# ^^    ^^    ^^    ^^    ^^ string.regexp.double-quoted.php constant.character.escape.php - constant.character.escape.regexp.php
#   ^^    ^^    ^^    ^^    ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.double-quoted.php constant.character.class.wildcard.regexp.php
#           ^ string.regexp.double-quoted.php keyword.operator.or.regexp.php
#                 ^     ^     ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php

'/\\\\. \\\\| \\\\? \\\\+ \\\\*/';
# ^^    ^^    ^^    ^^    ^^ string.regexp.single-quoted.php constant.character.escape.php - constant.character.escape.regexp.php
#   ^^    ^^    ^^    ^^    ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.single-quoted.php constant.character.class.wildcard.regexp.php
#           ^ string.regexp.single-quoted.php keyword.operator.or.regexp.php
#                 ^     ^     ^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php

<<<REGEX
 /\\\\. \\\\| \\\\? \\\\+ \\\\*/
# ^^    ^^    ^^    ^^    ^^ string.regexp.heredoc.php constant.character.escape.php - constant.character.escape.regexp.php
#   ^^    ^^    ^^    ^^    ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.heredoc.php constant.character.class.wildcard.regexp.php
#           ^ string.regexp.heredoc.php keyword.operator.or.regexp.php
#                 ^     ^     ^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
REGEX;

<<<'REGEXP'
 /\\\\. \\\\| \\\\? \\\\+ \\\\*/
# ^^^^  ^^^^  ^^^^  ^^^^  ^^^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#     ^ string.regexp.nowdoc.php constant.character.class.wildcard.regexp.php
#           ^ string.regexp.nowdoc.php keyword.operator.or.regexp.php
#                 ^     ^     ^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
REGEXP;
