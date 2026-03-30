# SYNTAX TEST "source.php" "regex quantifiers"
<?php

// Range quantifiers in quoted regex wrappers.

// Extracted from: should tokenize quoted regex range quantifiers without string-only legacy scopes
 '/a{3,4}+/';
#   ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#    ^^^ ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#       ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php

// Extracted from: should tokenize quoted regex range quantifiers without string-only legacy scopes
 "/a{,4}?/";
#   ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#    ^^ ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#      ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php

// Mixed body operators and quantifiers in quoted regex wrappers.

// Extracted from: should tokenize richer body escapes and operators in double quoted regexes
 "/^\d|\p{L}.+\x{4A}$/";
#  ^                ^ string.regexp.double-quoted.php keyword.control.anchor.regexp.php
#   ^^ ^^^^^ string.regexp.double-quoted.php constant.character.class.regexp.php
#     ^ string.regexp.double-quoted.php keyword.operator.or.regexp.php
#           ^ string.regexp.double-quoted.php constant.character.class.wildcard.regexp.php
#            ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php
#             ^^^^^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize richer body escapes and operators in single quoted regexes
 '/^\d|\pL\p{L}.+\x41\x{4A}$/';
#  ^                       ^ string.regexp.single-quoted.php keyword.control.anchor.regexp.php
#   ^^ ^^^^^^^^ string.regexp.single-quoted.php constant.character.class.regexp.php
#     ^ string.regexp.single-quoted.php keyword.operator.or.regexp.php
#              ^ string.regexp.single-quoted.php constant.character.class.wildcard.regexp.php
#               ^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php
#                ^^^^^^^^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Quantifier-heavy explicit hosts.

// Extracted from: should tokenize anchors, dots, alternation, and quantifiers in REGEX heredoc
<<<REGEX
  /^\A.a+?|b{2,4}+$/
#       ^^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
#           ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#            ^^^ ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#               ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php
REGEX;

// Extracted from: should tokenize anchors, dots, alternation, and quantifiers in REGEXP nowdoc
<<<'REGEXP'
  /^\A.a+?|b{2,4}+$/
#       ^^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
#           ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#            ^^^ ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#               ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php
REGEXP;

// Extracted from: should tokenize simple quantifier variants in REGEX heredoc
<<<REGEX
  /a?b??c?+d+e++f+?g*h*?i*+/
#   ^ ^^ ^^ ^ ^^ ^^ ^ ^^ ^^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
REGEX;

// Extracted from: should tokenize simple quantifier variants in REGEXP nowdoc
<<<'REGEXP'
  /a?b??c?+d+e++f+?g*h*?i*+/
#   ^ ^^ ^^ ^ ^^ ^^ ^ ^^ ^^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
REGEXP;
