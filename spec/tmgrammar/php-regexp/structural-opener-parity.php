# SYNTAX TEST "source.php" "regex structural opener parity"
<?php

// Character classes

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 "/\\[a]/";
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 "/\\\[a]/";
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 '/\\[a]/';
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 '/\\\[a]/';
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#     ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

// Extracted from: should tokenize supported structural opener parity in REGEX heredoc from fixtures
<<<REGEX
  /\\[a]/
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize supported structural opener parity in REGEX heredoc from fixtures
<<<REGEX
  /\\\[a]/
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#     ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEX;

// Extracted from: should tokenize supported structural opener parity in REGEXP nowdoc from fixtures
<<<'REGEXP'
  /\[a]/
#  ^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize supported structural opener parity in REGEXP nowdoc from fixtures
<<<'REGEXP'
  /\\[a]/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#    ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#      ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEXP;

// Groups

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 "/\\(a)/";
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 "/\\\(a)/";
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#      ^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 '/\\(a)/';
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 '/\\\(a)/';
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#      ^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php

// Extracted from: should tokenize supported structural opener parity in REGEX heredoc from fixtures
<<<REGEX
  /\\(a)/
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize supported structural opener parity in REGEX heredoc from fixtures
<<<REGEX
  /\\\(a)/
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#      ^ meta.embedded.group.regexp.php string.regexp.heredoc.php
#       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
REGEX;

// Extracted from: should tokenize supported structural opener parity in REGEXP nowdoc from fixtures
<<<'REGEXP'
  /\(a)/
#  ^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize supported structural opener parity in REGEXP nowdoc from fixtures
<<<'REGEXP'
  /\\(a)/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#    ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#     ^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
#      ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
REGEXP;

// Quantifiers

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 "/\\{1}/";
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 "/\\\{1}/";
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#      ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#       ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 '/\\{1}/';
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize supported structural opener parity in interpreted quoted regexes from fixtures
 '/\\\{1}/';
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#     ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#      ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#       ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php

// Extracted from: should tokenize supported structural opener parity in REGEX heredoc from fixtures
<<<REGEX
  /\\{1}/
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize supported structural opener parity in REGEX heredoc from fixtures
<<<REGEX
  /\\\{1}/
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#     ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#      ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#       ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php
REGEX;

// Extracted from: should tokenize supported structural opener parity in REGEXP nowdoc from fixtures
<<<'REGEXP'
  /\{1}/
#  ^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize supported structural opener parity in REGEXP nowdoc from fixtures
<<<'REGEXP'
  /\\{1}/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#    ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php
#     ^ meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#      ^ meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.end.regexp.php
REGEXP;
