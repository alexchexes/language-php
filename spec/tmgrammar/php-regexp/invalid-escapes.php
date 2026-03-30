# SYNTAX TEST "source.php" "regex invalid escapes"
<?php

// Malformed braced hex and octal escapes

// Extracted from: tokenizes closed malformed raw braced hex and octal escapes as invalid in double quoted regexes and classes
 "/\x{1,2}\o{abc}/";
#  ^^^^^^^^^^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes closed malformed raw braced hex and octal escapes as invalid in double quoted regexes and classes
 "/[\x{1,2}\o{abc}]/";
#   ^^^^^^^^^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes closed malformed raw braced hex and octal escapes as invalid in REGEXP nowdoc
<<<'REGEXP'
  /\x{1,2}\o{abc}/
#  ^^^^^^^^^^^^^^ string.regexp.nowdoc.php invalid.illegal.escape.regexp.php
REGEXP;

// Extracted from: tokenizes closed malformed raw braced hex and octal escapes as invalid in REGEXP nowdoc
<<<'REGEXP'
  /[\x{1,2}\o{abc}]/
#   ^^^^^^^^^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
REGEXP;

// Extracted from: tokenizes closed malformed decoded braced hex and octal escapes as invalid in double quoted regexes and classes
 "/\\x{1,2}\\o{abc}/";
#  ^^      ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#    ^^^^^^  ^^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes closed malformed decoded braced hex and octal escapes as invalid in double quoted regexes and classes
 "/[\\x{1,2}\\o{abc}]/";
#   ^^      ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#     ^^^^^^  ^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes closed malformed decoded braced hex and octal escapes as invalid in REGEX heredoc
<<<REGEXP
  /\\x{1,2}\\o{abc}/
#  ^^      ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#    ^^^^^^  ^^^^^^ string.regexp.heredoc.php invalid.illegal.escape.regexp.php
REGEXP;

// Extracted from: tokenizes closed malformed decoded braced hex and octal escapes as invalid in REGEX heredoc
<<<REGEXP
  /[\\x{1,2}\\o{abc}]/
#   ^^      ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#     ^^^^^^  ^^^^^^ constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
REGEXP;

// Malformed named backreference and subroutine escapes

// Extracted from: tokenizes closed malformed raw \k/\g forms as invalid in quoted regexes
 "/\k{}\k{1}\k<١foo>\k<a💩>/";
#  ^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes closed malformed raw \k/\g forms as invalid in quoted regexes
 "/\g{}\g{1x}\g<💩>\g{a💩}/";
#  ^^^^^^^^^^^^^^^^^^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes every closed malformed raw \k form as invalid in REGEXP nowdoc
<<<'REGEXP'
  /\k{}\k{1}\k{١foo}\k{a💩}/
#  ^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.nowdoc.php invalid.illegal.escape.regexp.php
REGEXP;

// Extracted from: tokenizes every closed malformed raw \g form as invalid in REGEXP nowdoc
<<<'REGEXP'
  /\g{}\g{+}\g{1x}\g{١foo}/
#  ^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.nowdoc.php invalid.illegal.escape.regexp.php
REGEXP;

// Extracted from: tokenizes closed malformed decoded \k/\g forms as invalid in quoted regexes
 "/\\k{}\\k<١foo>\\k<a💩>/";
#  ^^   ^^       ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#    ^^^  ^^^^^^^  ^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes closed malformed decoded \k/\g forms as invalid in quoted regexes
 "/\\g{}\\g{1x}\\g{١foo}/";
#  ^^   ^^     ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#    ^^^  ^^^^^  ^^^^^^^ string.regexp.double-quoted.php invalid.illegal.escape.regexp.php

// Extracted from: tokenizes every closed malformed decoded \k form as invalid in REGEX heredoc
<<<REGEXP
  /\\k{}\\k{1}\\k{١foo}\\k{a💩}/
#  ^^   ^^    ^^       ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#    ^^^  ^^^^  ^^^^^^^  ^^^^^ string.regexp.heredoc.php invalid.illegal.escape.regexp.php
REGEXP;

// Extracted from: tokenizes every closed malformed decoded \g form as invalid in REGEX heredoc
<<<REGEXP
  /\\g{}\\g{+}\\g{1x}\\g{١foo}/
#  ^^   ^^    ^^     ^^ constant.character.escape.php invalid.illegal.escape.regexp.php
#    ^^^  ^^^^  ^^^^^  ^^^^^^^ string.regexp.heredoc.php invalid.illegal.escape.regexp.php
REGEXP;
