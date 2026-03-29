# SYNTAX TEST "source.php" "regex brace quantifier edge cases"
<?php

// Malformed braced quantifier text stays plain.

// Extracted from: should keep malformed braced quantifier text plain in quoted regex bodies
 '/a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/';
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.single-quoted.php - constant.character.numeric.regexp.php keyword.operator.quantifier.regexp.php meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php

// Extracted from: should keep malformed braced quantifier text plain in quoted regex bodies
 "/a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/";
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.double-quoted.php - constant.character.numeric.regexp.php keyword.operator.quantifier.regexp.php meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php

// Extracted from: should keep malformed braced quantifier text plain in REGEX heredoc
<<<REGEX
  /a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.heredoc.php - constant.character.numeric.regexp.php keyword.operator.quantifier.regexp.php meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
REGEX;

// Extracted from: should keep malformed braced quantifier text plain in REGEXP nowdoc
<<<'REGEXP'
  /a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.nowdoc.php - constant.character.numeric.regexp.php keyword.operator.quantifier.regexp.php meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
REGEXP;

// `+` can quantify a literal opening brace, but `{-1}` stays plain text.

// Extracted from: should let + quantify a literal opening brace in quoted regex bodies
 '/a{+1}/';
#  ^^ string.regexp.single-quoted.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#    ^ string.regexp.single-quoted.php keyword.operator.quantifier.regexp.php
#     ^^ string.regexp.single-quoted.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php constant.character.numeric.regexp.php

// Extracted from: should let + quantify a literal opening brace in quoted regex bodies
 '/a{-1}/';
#  ^^^^^ string.regexp.single-quoted.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php keyword.operator.quantifier.regexp.php constant.character.numeric.regexp.php

// Extracted from: should let + quantify a literal opening brace in quoted regex bodies
 "/a{+1}/";
#  ^^ string.regexp.double-quoted.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#    ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php
#     ^^ string.regexp.double-quoted.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php constant.character.numeric.regexp.php

// Extracted from: should let + quantify a literal opening brace in quoted regex bodies
 "/a{-1}/";
#  ^^^^^ string.regexp.double-quoted.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php keyword.operator.quantifier.regexp.php constant.character.numeric.regexp.php

// Extracted from: should let + quantify a literal opening brace in REGEX heredoc
<<<REGEX
  /a{+1}/
#  ^^ string.regexp.heredoc.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#    ^ string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
#     ^^ string.regexp.heredoc.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php constant.character.numeric.regexp.php
REGEX;

// Extracted from: should let + quantify a literal opening brace in REGEX heredoc
<<<REGEX
  /a{-1}/
#  ^^^^^ string.regexp.heredoc.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php keyword.operator.quantifier.regexp.php constant.character.numeric.regexp.php
REGEX;

// Extracted from: should let + quantify a literal opening brace in REGEXP nowdoc
<<<'REGEXP'
  /a{+1}/
#  ^^ string.regexp.nowdoc.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#    ^ string.regexp.nowdoc.php keyword.operator.quantifier.regexp.php
#     ^^ string.regexp.nowdoc.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php constant.character.numeric.regexp.php
REGEXP;

// Extracted from: should let + quantify a literal opening brace in REGEXP nowdoc
<<<'REGEXP'
  /a{-1}/
#  ^^^^^ string.regexp.nowdoc.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php keyword.operator.quantifier.regexp.php constant.character.numeric.regexp.php
REGEXP;

// Braced quantifier-like text stays literal inside character classes.

// Extracted from: should keep braced quantifier-like text literal inside quoted regex character classes
 '/[{1}]/';
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^ ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#    ^ constant.other.character-class.set.regexp.php constant.numeric.regexp.php

// Extracted from: should keep braced quantifier-like text literal inside quoted regex character classes
 "/[{1}]/";
#  ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^ ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#    ^ constant.other.character-class.set.regexp.php constant.numeric.regexp.php

// Extracted from: should keep braced quantifier-like text literal inside character classes in REGEX heredoc
<<<REGEX
 /[{1}]/
# ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#  ^ ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#   ^ constant.other.character-class.set.regexp.php constant.numeric.regexp.php
REGEX;

// Extracted from: should keep braced quantifier-like text literal inside character classes in REGEXP nowdoc
<<<'REGEXP'
 /[{1}]/
# ^   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#  ^ ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php - meta.embedded.quantifier.range.regexp.php punctuation.definition.quantifier.begin.regexp.php punctuation.definition.quantifier.end.regexp.php
#   ^ constant.other.character-class.set.regexp.php constant.numeric.regexp.php
REGEXP;
