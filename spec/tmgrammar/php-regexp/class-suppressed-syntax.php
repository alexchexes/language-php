# SYNTAX TEST "source.php" "regex class-suppressed syntax"
<?php

// Additional tmgrammar coverage: regex syntax that should stay literal inside
// character classes.

// Single-character operator-like punctuation

// Extracted from: should keep operator-looking punctuation literal inside quoted regex character classes
 '/[.?+*^$|()]/';
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#   ^^^^^^^^^ - punctuation.definition.group.regexp.php

// Extracted from: should keep operator-looking punctuation literal inside quoted regex character classes
 "/[.?+*^$|()]/";
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#   ^^^^^^^^^ - punctuation.definition.group.regexp.php

// Extracted from: should keep operator-looking punctuation literal inside character classes in REGEX heredoc
<<<REGEX
 /[.?+*^$|()]/
# ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#  ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#  ^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#  ^^^^^^^^^ - punctuation.definition.group.regexp.php
REGEX;

// Extracted from: should keep operator-looking punctuation literal inside character classes in REGEXP nowdoc
<<<'REGEXP'
 /[.?+*^$|()]/
# ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#  ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#  ^^^^^^^^^ - keyword.operator.quantifier.regexp.php keyword.control.anchor.regexp.php keyword.operator.or.regexp.php
#  ^^^^^^^^^ - punctuation.definition.group.regexp.php
REGEXP;

// Parenthesized compound starters

 '/[(?:]/';
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php

<<<'REGEXP'
  /[(?:]/
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
REGEXP;

 '/[(?<]/';
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.capture.begin.regexp.php

<<<'REGEXP'
  /[(?<]/
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.capture.begin.regexp.php
REGEXP;

 '/[(?(]/';
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^^^ - punctuation.definition.group.conditional.regexp.php punctuation.definition.group.regexp.php

<<<'REGEXP'
  /[(?(]/
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^^^ - punctuation.definition.group.conditional.regexp.php punctuation.definition.group.regexp.php
REGEXP;

 '/[(?#]/';
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php

<<<'REGEXP'
  /[(?#]/
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^ - meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
REGEXP;

// Backtracking verbs, named backreferences, and named subroutines

 '/[(*MARK:x)]/';
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php variable.other.regexp.php

<<<'REGEXP'
  /[(*MARK:x)]/
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php variable.other.regexp.php
REGEXP;

 '/[(?P=word)]/';
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^ - keyword.other.back-reference.named.regexp.php variable.other.regexp.php

<<<'REGEXP'
  /[(?P=word)]/
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^ - keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEXP;

 '/[(?P>word)]/';
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php

<<<'REGEXP'
  /[(?P>word)]/
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
REGEXP;

 '/[(?&word)]/';
#  ^        ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php

<<<'REGEXP'
  /[(?&word)]/
#  ^        ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^^^^^^^ - meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^ - keyword.other.subroutine.named.regexp.php variable.other.regexp.php
REGEXP;
