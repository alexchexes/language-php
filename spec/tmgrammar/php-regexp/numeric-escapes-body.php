# SYNTAX TEST "source.php" "regex body numeric escapes"
<?php

// Raw quoted body numeric escapes

// Extracted from: should tokenize raw Unicode code point escapes in quoted regexes
 "/\N{U+41}/";
#  ^^^^^^^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw Unicode code point escapes in quoted regexes
 '/\N{U+41}/';
#  ^^^^^^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw braced octal escapes in quoted regexes
 "/\o{141}/";
#  ^^^^^^^ string.regexp.double-quoted.php constant.numeric.octal.regexp.php

// Extracted from: should tokenize raw braced octal escapes in quoted regexes
 '/\o{141}/';
#  ^^^^^^^ string.regexp.single-quoted.php constant.numeric.octal.regexp.php

// Extracted from: should tokenize raw octal escapes in single quoted regexes
 '/\0 \00 \000 \o{141}/';
#  ^^ ^^^ ^^^^ ^^^^^^^ string.regexp.single-quoted.php constant.numeric.octal.regexp.php
#    ^   ^    ^ string.regexp.single-quoted.php - constant.numeric.octal.regexp.php

// Raw full-hex body forms in single quoted regexes.
 '/\x41 \x{4A}/';
#  ^^^^ ^^^^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#      ^ string.regexp.single-quoted.php - constant.character.numeric.regexp.php

// Decoded quoted body numeric escapes

// Extracted from: should tokenize decoded octal zero in double quoted regex bodies
 "/\\0/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.numeric.octal.regexp.php
#    ^ string.regexp.double-quoted.php constant.numeric.octal.regexp.php

// Extracted from: should tokenize decoded overlapping escapes in double quoted regexes
 "/\\x41/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded overlapping escapes in single quoted regexes
 '/\\x41/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded property, braced hex, braced octal, and Unicode code point escapes in quoted regexes
 "/\\x{41} \\o{141} \\N{U+41}/";
#  ^^               ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^^^^            ^^^^^^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php
#          ^^ string.regexp.double-quoted.php constant.character.escape.php constant.numeric.octal.regexp.php
#            ^^^^^^ string.regexp.double-quoted.php constant.numeric.octal.regexp.php

// Extracted from: should tokenize decoded property, braced hex, braced octal, and Unicode code point escapes in quoted regexes
 '/\\x{41} \\o{141} \\N{U+41}/';
#  ^^               ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^^^^            ^^^^^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#          ^^ string.regexp.single-quoted.php constant.character.escape.php constant.numeric.octal.regexp.php
#            ^^^^^^ string.regexp.single-quoted.php constant.numeric.octal.regexp.php

// Raw explicit body numeric escapes

// Extracted from: should tokenize braced octal escapes in REGEX heredoc
<<<REGEX
 /\o{141}/
# ^^^^^^^ string.regexp.heredoc.php constant.numeric.octal.regexp.php
REGEX;

// Extracted from: should tokenize raw octal zero escapes in REGEXP nowdoc
<<<'REGEXP'
  /\0 \00 \000/
#  ^^ ^^^ ^^^^ string.regexp.nowdoc.php constant.numeric.octal.regexp.php
#    ^   ^ string.regexp.nowdoc.php - constant.numeric.octal.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw octal-escape surface in REGEXP nowdoc
<<<'REGEXP'
  /\0 \07 \012 \o{141}/
#  ^^ ^^^ ^^^^ ^^^^^^^ string.regexp.nowdoc.php constant.numeric.octal.regexp.php
#    ^   ^    ^ string.regexp.nowdoc.php - constant.numeric.octal.regexp.php
REGEXP;

// Extracted from: should tokenize braced octal escapes in REGEXP nowdoc
<<<'REGEXP'
  /\o{141}/
#  ^^^^^^^ string.regexp.nowdoc.php constant.numeric.octal.regexp.php
REGEXP;

// Extracted from: should tokenize Unicode code point escapes in REGEXP nowdoc
<<<'REGEXP'
  /\N{U+41}/
#  ^^^^^^^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize raw two-digit hex escapes in REGEXP nowdoc
<<<'REGEXP'
  /\x41 \xAf/
#  ^^^^ ^^^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
#      ^ string.regexp.nowdoc.php - constant.character.numeric.regexp.php
REGEXP;

// Extracted from: should tokenize raw braced hex escapes in REGEXP nowdoc
<<<'REGEXP'
  /\x{4A} \x{1F600}/
#  ^^^^^^ ^^^^^^^^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
#        ^ string.regexp.nowdoc.php - constant.character.numeric.regexp.php
REGEXP;

// Decoded explicit body numeric escapes

// Extracted from: should tokenize decoded octal zero in REGEX heredoc bodies
<<<REGEX
 /\\0/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.numeric.octal.regexp.php
#   ^ string.regexp.heredoc.php constant.numeric.octal.regexp.php
REGEX;

// Extracted from: should keep single-backslash overlapping escapes PHP-first in REGEX heredoc
<<<REGEX
 /\\x41/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Extracted from: should tokenize decoded property, braced hex, and braced octal escapes in REGEX heredoc
<<<REGEX
 /\\x{41} \\o{141}/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^^^^^     string.regexp.heredoc.php constant.character.numeric.regexp.php
#         ^^ string.regexp.heredoc.php constant.character.escape.php constant.numeric.octal.regexp.php
#           ^^^^^^ string.regexp.heredoc.php constant.numeric.octal.regexp.php
REGEX;

// Extracted from: should tokenize Unicode code point escapes in REGEX heredoc
<<<REGEX
 /\\N{U+41}/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^^^^^^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;
