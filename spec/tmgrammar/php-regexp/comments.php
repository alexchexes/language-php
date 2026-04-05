# SYNTAX TEST "source.php" "regex comments"
<?php

// Extracted from: should tokenize comment groups in quoted regex strings
 "/(?# note)/";
#  ^^^ string.regexp.double-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.double-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.double-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php

// Extracted from: should tokenize comment groups in quoted regex strings
 '/(?# note)/';
#  ^^^ string.regexp.single-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.single-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.single-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php

// Extracted from: should tokenize comment groups in REGEX heredoc
<<<REGEX
  /(?# note)/
#  ^^^ string.regexp.heredoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.heredoc.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.heredoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php
REGEX;

// Extracted from: should tokenize comment groups in REGEXP nowdoc
<<<'REGEXP'
  /(?# note)/
#  ^^^ string.regexp.nowdoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.nowdoc.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.nowdoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php
REGEXP;

// Operator-like punctuation should stay suppressed inside comment groups

 "/(?#.?+*^$|)/";
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - constant.character.class.wildcard.regexp.php keyword.operator.quantifier.regexp.php
#     ^^^^^^^ - keyword.control.anchor.regexp.php keyword.operator.or.regexp.php

 '/(?#.?+*^$|)/';
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - constant.character.class.wildcard.regexp.php keyword.operator.quantifier.regexp.php
#     ^^^^^^^ - keyword.control.anchor.regexp.php keyword.operator.or.regexp.php

<<<REGEX
  /(?#.?+*^$|)/
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - constant.character.class.wildcard.regexp.php keyword.operator.quantifier.regexp.php
#     ^^^^^^^ - keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
REGEX;

<<<'REGEXP'
  /(?#.?+*^$|)/
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - constant.character.class.wildcard.regexp.php keyword.operator.quantifier.regexp.php
#     ^^^^^^^ - keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
REGEXP;

 "/(?#[])/";
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

 '/(?#[])/';
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

<<<REGEX
  /(?#[])/
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEX;

<<<'REGEXP'
  /(?#[])/
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEXP;

// Group introducers should stay suppressed inside comment groups

 "/(?#(?:(?<(?P<)/";
#     ^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php variable.other.regexp.php

 '/(?#(?:(?<(?P<)/';
#     ^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php variable.other.regexp.php

<<<REGEX
  /(?#(?:(?<(?P<)/
#     ^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php variable.other.regexp.php
REGEX;

<<<'REGEXP'
  /(?#(?:(?<(?P<)/
#     ^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php variable.other.regexp.php
REGEXP;

 "/(?#(?(word)/";
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^ - meta.embedded.group.conditional.regexp.php variable.other.regexp.php

 '/(?#(?(word)/';
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^ - meta.embedded.group.conditional.regexp.php variable.other.regexp.php

<<<REGEX
  /(?#(?(word)/
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^ - meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEX;

<<<'REGEXP'
  /(?#(?(word)/
#     ^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^ - punctuation.definition.group.regexp.php
#     ^^^^^^^ - meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEXP;

 "/(?#(?|(?>)/";
#     ^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.group.atomic.regexp.php punctuation.definition.group.branch-reset.regexp.php

 '/(?#(?|(?>)/';
#     ^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.group.atomic.regexp.php punctuation.definition.group.branch-reset.regexp.php

<<<REGEX
  /(?#(?|(?>)/
#     ^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.group.atomic.regexp.php punctuation.definition.group.branch-reset.regexp.php
REGEX;

<<<'REGEXP'
  /(?#(?|(?>)/
#     ^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.group.atomic.regexp.php punctuation.definition.group.branch-reset.regexp.php
REGEXP;

// Backslash-led named constructs should stay suppressed inside comment groups

 "/(?#\k<word>\k{word}\g{word})/";
#     ^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.back-reference.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php

 '/(?#\k<word>\k{word}\g{word})/';
#     ^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.back-reference.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php

<<<REGEX
  /(?#\k<word>\k{word}\g{word})/
#     ^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.back-reference.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php
REGEX;

<<<'REGEXP'
  /(?#\k<word>\k{word}\g{word})/
#     ^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.back-reference.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php
REGEXP;

 "/(?#\g<word>)/";
#     ^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php

 '/(?#\g<word>)/';
#     ^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php

<<<REGEX
  /(?#\g<word>)/
#     ^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php
REGEX;

<<<'REGEXP'
  /(?#\g<word>)/
#     ^^^^^^^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#     ^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php punctuation.definition.group.capture.end.regexp.php
REGEXP;

 "/(?#\Q)/";
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - constant.character.escape.regexp.php meta.embedded.quoted-literal.regexp.php

 '/(?#\Q)/';
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - constant.character.escape.regexp.php meta.embedded.quoted-literal.regexp.php

<<<REGEX
  /(?#\Q)/
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - constant.character.escape.regexp.php meta.embedded.quoted-literal.regexp.php
REGEX;

<<<'REGEXP'
  /(?#\Q)/
#     ^^ meta.embedded.group.regexp.php comment.block.regexp.php
#     ^^ - constant.character.escape.regexp.php meta.embedded.quoted-literal.regexp.php
REGEXP;

// Explicit line comments

// Extracted from: should tokenize line comments in REGEX heredoc
<<<REGEX
 /a # note
#   ^ punctuation.definition.comment.php
#   ^^^^^^ string.regexp.heredoc.php comment.line.number-sign.php
 b/
REGEX;

// Extracted from: should tokenize line comments in REGEXP nowdoc
<<<'REGEXP'
 /a # note
#   ^ punctuation.definition.comment.php
#   ^^^^^^ string.regexp.nowdoc.php comment.line.number-sign.php
 b/
REGEXP;

// Extracted from: should allow only the conservative explicit # comment starters in REGEX heredoc
<<<REGEX
 a # note
#  ^ punctuation.definition.comment.php
#  ^^^^^^ string.regexp.heredoc.php comment.line.number-sign.php
 b # 1
#  ^ punctuation.definition.comment.php
#  ^^^ string.regexp.heredoc.php comment.line.number-sign.php
 c # _
#  ^ punctuation.definition.comment.php
#  ^^^ string.regexp.heredoc.php comment.line.number-sign.php
 d # ?
#  ^ punctuation.definition.comment.php
#  ^ string.regexp.heredoc.php comment.line.number-sign.php punctuation.definition.comment.php
 e #	note
#  ^ punctuation.definition.comment.php
#  ^^^^^^ string.regexp.heredoc.php comment.line.number-sign.php
 f #
#  ^ string.regexp.heredoc.php comment.line.number-sign.php punctuation.definition.comment.php
 z
REGEX;

// Extracted from: should allow only the conservative explicit # comment starters in REGEXP nowdoc
<<<'REGEXP'
 a # note
#  ^ punctuation.definition.comment.php
#  ^^^^^^ string.regexp.nowdoc.php comment.line.number-sign.php
 b # 1
#  ^ punctuation.definition.comment.php
#  ^^^ string.regexp.nowdoc.php comment.line.number-sign.php
 c # _
#  ^ punctuation.definition.comment.php
#  ^^^ string.regexp.nowdoc.php comment.line.number-sign.php
 d # ?
#  ^ punctuation.definition.comment.php
#  ^ string.regexp.nowdoc.php comment.line.number-sign.php punctuation.definition.comment.php
 e #	note
#  ^ punctuation.definition.comment.php
#  ^^^^^^ string.regexp.nowdoc.php comment.line.number-sign.php
 f #
#  ^ string.regexp.nowdoc.php comment.line.number-sign.php punctuation.definition.comment.php
 z
REGEXP;

// Extracted from: should keep disallowed explicit # starters plain in REGEX heredoc
<<<REGEX
 a# note
# ^^^^^^^ string.regexp.heredoc.php - comment.line.number-sign.php
 b #note
# ^^^^^^^ string.regexp.heredoc.php - comment.line.number-sign.php
 c # :
# ^^^^^^ string.regexp.heredoc.php - comment.line.number-sign.php
 z
REGEX;

// Extracted from: should keep disallowed explicit # starters plain in REGEXP nowdoc
<<<'REGEXP'
 a# note
# ^^^^^^^ string.regexp.nowdoc.php - comment.line.number-sign.php
 b #note
# ^^^^^^^ string.regexp.nowdoc.php - comment.line.number-sign.php
 c # :
# ^^^^^^ string.regexp.nowdoc.php - comment.line.number-sign.php
 z
REGEXP;
