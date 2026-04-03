# SYNTAX TEST "source.php" "regex quoted literals"
<?php

// Raw quoted literals

// Extracted from: should tokenize quoted literals in quoted regex strings
 '/\Qfoo/bar\E\d/';
#  ^^       ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#             ^^ string.regexp.single-quoted.php constant.character.class.regexp.php

// Extracted from: should tokenize quoted literals in quoted regex strings
 "/\Qfoo/bar\E\d/";
#  ^^       ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#             ^^ string.regexp.double-quoted.php constant.character.class.regexp.php

// Extracted from: should tokenize quoted literals in REGEX heredoc
<<<REGEX
  /\Qfoo/bar\E\d/
#  ^^       ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#             ^^ string.regexp.heredoc.php constant.character.class.regexp.php
REGEX;

// Extracted from: should tokenize quoted literals in REGEXP nowdoc
<<<'REGEXP'
  /\Qfoo/bar\E\d/
#  ^^       ^^ string.regexp.nowdoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^ string.regexp.nowdoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#             ^^ string.regexp.nowdoc.php constant.character.class.regexp.php
REGEXP;

// Extracted from: should keep operator-looking punctuation literal inside quoted regex quoted literals
 '/\Q.?+*^$|()[]\E/';
#  ^^           ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#    ^^^^^^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php

// Extracted from: should keep operator-looking punctuation literal inside quoted regex quoted literals
 "/\Q.?+*^$|()[]\E/";
#  ^^           ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#    ^^^^^^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php

// Extracted from: should keep operator-looking punctuation literal inside quoted literals in REGEX heredoc
<<<REGEX
  /\Q.?+*^$|()[]\E/
#  ^^           ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#    ^^^^^^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php
REGEX;

// Extracted from: should keep operator-looking punctuation literal inside quoted literals in REGEXP nowdoc
<<<'REGEXP'
  /\Q.?+*^$|()[]\E/
#  ^^           ^^ string.regexp.nowdoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^ string.regexp.nowdoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#    ^^^^^^^^^^^ - punctuation.definition.group.regexp.php punctuation.definition.character-class.regexp.php
REGEXP;

// Additional tmgrammar coverage: compound syntax should stay literal inside
// quoted literals.

 '/\Q(?:)(?<)(?(x))(?#x)(*MARK:x)(?P=word)(?P>word)(?&word)\E/';
#  ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.no-capture.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.conditional.regexp.php comment.block.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.comment.begin.regexp.php punctuation.definition.comment.end.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.other.back-reference.named.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#                                                          ^^ meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

 "/\Q(?:)(?<)(?(x))(?#x)(*MARK:x)(?P=word)(?P>word)(?&word)\E/";
#  ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.no-capture.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.conditional.regexp.php comment.block.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.comment.begin.regexp.php punctuation.definition.comment.end.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.other.back-reference.named.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#                                                          ^^ meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php

<<<REGEX
  /\Q(?:)(?<)(?(x))(?#x)(*MARK:x)(?P=word)(?P>word)(?&word)\E/
#  ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.no-capture.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.conditional.regexp.php comment.block.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.comment.begin.regexp.php punctuation.definition.comment.end.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.other.back-reference.named.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#                                                          ^^ meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
REGEX;

<<<'REGEXP'
  /\Q(?:)(?<)(?(x))(?#x)(*MARK:x)(?P=word)(?P>word)(?&word)\E/
#  ^^ string.regexp.nowdoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.no-capture.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.capture.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.group.conditional.regexp.php comment.block.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - punctuation.definition.comment.begin.regexp.php punctuation.definition.comment.end.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.other.back-reference.named.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
#                                                          ^^ meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
REGEXP;

// Decoded quoted literals

// Extracted from: should tokenize decoded quoted literals in quoted regex strings
 "/\\Qfoo/bar\\E/";
#  ^^        ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#    ^         ^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php

// Extracted from: should tokenize decoded quoted literals in quoted regex strings
 '/\\Qfoo/bar\\E/';
#  ^^        ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#    ^         ^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php

// Extracted from: should tokenize decoded quoted literals in REGEXP heredoc
<<<REGEXP
  /\\Qfoo/bar\\E/
#  ^^        ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#    ^         ^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
REGEXP;

// Asymmetric quoted-literal boundaries

// Extracted from: should tokenize asymmetric quoted-literal boundaries in quoted regex strings
 "/\\Qabc\E/";
#  ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#    ^   ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php

// Extracted from: should tokenize asymmetric quoted-literal boundaries in quoted regex strings
 "/\Qabc\\E/";
#  ^^     ^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#       ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php

// Extracted from: should tokenize asymmetric quoted-literal boundaries in quoted regex strings
 '/\\Qabc\E/';
#  ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#    ^   ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php

// Extracted from: should tokenize asymmetric quoted-literal boundaries in quoted regex strings
 '/\Qabc\\E/';
#  ^^     ^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#       ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php

// Extracted from: should tokenize asymmetric quoted-literal boundaries in REGEXP heredoc
<<<REGEXP
  /\\Qabc\E/
#  ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
#    ^   ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#     ^^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
REGEXP;

// Extracted from: should tokenize asymmetric quoted-literal boundaries in REGEXP heredoc
<<<REGEXP
  /\Qabc\\E/
#  ^^     ^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php
#       ^^ string.regexp.heredoc.php meta.embedded.quoted-literal.regexp.php constant.character.escape.php
REGEXP;

// Wrapper-quote escapes inside quoted literals

// Extracted from: should enter regex mode for same-host quote escapes inside quoted literals
 "/\Q\"\E/";
#  ^^  ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^ string.regexp.double-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php

// Extracted from: should enter regex mode for same-host quote escapes inside quoted literals
 '/\Q\'\E/';
#  ^^  ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php constant.character.escape.regexp.php
#    ^^ string.regexp.single-quoted.php meta.embedded.quoted-literal.regexp.php string.regexp.quoted-literal.php constant.character.escape.php

// End markers outside quoted literals

// Extracted from: should tokenize standalone quoted-literal end markers in quoted regex bodies
 '/\E/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize standalone quoted-literal end markers in quoted regex bodies
 "/\E/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize standalone quoted-literal end markers in REGEX heredoc
<<<REGEX
  /\E/
#  ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize standalone quoted-literal end markers in REGEXP nowdoc
<<<'REGEXP'
  /\E/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize decoded quoted-literal end markers outside quoted literals in quoted regex strings
 "/abc\\E/";
#     ^^ string.regexp.double-quoted.php constant.character.escape.php
#       ^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize decoded quoted-literal end markers outside quoted literals in quoted regex strings
 '/abc\\E/';
#     ^^ string.regexp.single-quoted.php constant.character.escape.php
#       ^ string.regexp.single-quoted.php constant.character.escape.regexp.php
