# SYNTAX TEST "source.php" "regex numeric backreferences"
<?php

// Raw quoted numeric backreferences

// Extracted from: should tokenize numeric g-style backreferences in quoted regexes
 "/\g1 \g{1} \g{-1}/";
#  ^^^ ^^^^^ ^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php
#    ^    ^     ^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
#        ^     ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^      ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^     ^ string.regexp.double-quoted.php - keyword.other.back-reference.regexp.php

// Extracted from: should tokenize numeric g-style backreferences in quoted regexes
 '/\g1 \g{1} \g{-1}/';
#  ^^^ ^^^^^ ^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php
#    ^    ^     ^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
#        ^     ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^      ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^     ^ string.regexp.single-quoted.php - keyword.other.back-reference.regexp.php

// Raw single-quoted numeric backreference \1.
 '/\1/';
#  ^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php
#   ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should keep double quoted numeric backreferences as PHP octal escapes
 "/\1/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.octal.php

// Extracted from: should tokenize the full double quoted raw 8/9 backreference surface
 "/\\8/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize the full double quoted raw 8/9 backreference surface
 "/\\9/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize the full double quoted raw 8/9 backreference surface
 "/\\80/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize the full double quoted raw 8/9 backreference surface
 "/\\99/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Decoded quoted numeric backreferences

// Extracted from: should tokenize decoded overlapping escapes in double quoted regexes
 "/\\1/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded overlapping escapes in single quoted regexes
 '/\\1/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Decoded g-style numeric backreferences

// Extracted from: should tokenize decoded numeric g-style backreferences in interpreted quoted regexes
 "/\\g1/";
#  ^^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded numeric g-style backreferences in interpreted quoted regexes
 '/\\g1/';
#  ^^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#     ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded numeric g-style backreferences in interpreted quoted regexes
 "/\\g{1}/";
#  ^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#       ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded numeric g-style backreferences in interpreted quoted regexes
 '/\\g{1}/';
#  ^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#     ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#       ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded numeric g-style backreferences in interpreted quoted regexes
 "/\\g{-1}/";
#  ^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#        ^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^ string.regexp.double-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded numeric g-style backreferences in interpreted quoted regexes
 '/\\g{-1}/';
#  ^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.regexp.php
#     ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#        ^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^ string.regexp.single-quoted.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php

// Extracted from: should tokenize decoded braced and g-style backreferences in REGEX heredoc
<<<REGEX
 /\\g1/
# ^^^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEX;

// Extracted from: should tokenize decoded braced and g-style backreferences in REGEX heredoc
<<<REGEX
 /\\g{1}/
# ^^^^^^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#      ^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEX;

// Extracted from: should tokenize decoded braced and g-style backreferences in REGEX heredoc
<<<REGEX
 /\\g{-1}/
# ^^^^^^^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#       ^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^ string.regexp.heredoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEX;

// Additional tmgrammar coverage: one-more-backslash transport spot checks.

 "/\\\g{1}/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php
#     ^ string.regexp.double-quoted.php - keyword.other.back-reference.regexp.php
#      ^^^ string.regexp.double-quoted.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php

 "/\\\\g{1}/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php - constant.character.escape.regexp.php
#    ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#      ^ string.regexp.double-quoted.php - keyword.other.back-reference.regexp.php
#       ^^^ string.regexp.double-quoted.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php

 '/\\\g{1}/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
#     ^ string.regexp.single-quoted.php - keyword.other.back-reference.regexp.php
#      ^^^ string.regexp.single-quoted.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php

 '/\\\\g{1}/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php - constant.character.escape.regexp.php
#    ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#      ^ string.regexp.single-quoted.php - keyword.other.back-reference.regexp.php
#       ^^^ string.regexp.single-quoted.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php

<<<REGEX
 /\\\g{1}/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^ string.regexp.heredoc.php constant.character.escape.regexp.php
#    ^ string.regexp.heredoc.php - keyword.other.back-reference.regexp.php
#     ^^^ string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
REGEX;

<<<REGEX
 /\\\\g{1}/
# ^^ string.regexp.heredoc.php constant.character.escape.php - constant.character.escape.regexp.php
#   ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#     ^ string.regexp.heredoc.php - keyword.other.back-reference.regexp.php
#      ^^^ string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
REGEX;

<<<'REGEXP'
 /\\g{1}/
# ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#   ^ string.regexp.nowdoc.php - keyword.other.back-reference.regexp.php
#    ^^^ string.regexp.nowdoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
REGEXP;

// Raw explicit-host numeric backreferences

// Extracted from: should tokenize raw numeric backreferences in REGEXP nowdoc
<<<'REGEXP'
 /\1/
# ^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#  ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize raw numeric backreferences in REGEXP nowdoc
<<<'REGEXP'
 /\12/
# ^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#  ^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize raw numeric backreferences in REGEXP nowdoc
<<<'REGEXP'
 /\123/
# ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#  ^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g1/
# ^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g+1/
# ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#   ^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g-1/
# ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#   ^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g{1}/
# ^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#     ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g{+1}/
# ^^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#      ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g{-1}/
# ^^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.begin.regexp.php
#      ^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^^ string.regexp.nowdoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
REGEXP;
