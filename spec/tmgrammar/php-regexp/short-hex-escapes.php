# SYNTAX TEST "source.php" "regex short hex escapes"
<?php

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 "/\x/";
#  ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 '/\x/';
#  ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 '/\x1Q600\x4Q/';
#  ^^^    ^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded one-digit hex escapes in quoted regexes
 "/\\x4Q/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded one-digit hex escapes in quoted regexes
 '/\\x1Q600/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw short hex escapes in REGEX heredoc
<<<REGEX
 /\x/
# ^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Extracted from: should tokenize one-digit hex escapes in REGEX heredoc
<<<REGEX
 /\\x1Q600\\x4Q/
# ^^      ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^^      ^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Extracted from: should tokenize one-digit hex escapes in REGEXP nowdoc
<<<'REGEXP'
  /\x1Q600\x4Q/
#  ^^^    ^^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
REGEXP;
