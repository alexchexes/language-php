# SYNTAX TEST "source.php" "regex short hex escapes"
<?php

// Short \x across quoted hosts

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 "/\x/";
#  ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Interpreted-host short \x in double quoted regexes.
 "/\\x/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 '/\x/';
#  ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Interpreted-host short \x in single quoted regexes.
 '/\\x/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// One-digit \xN across quoted hosts

// Raw one-digit \xN in double quoted regexes.
 "/\x1Q600 \x4Q/";
#  ^^^     ^^^ string.regexp.double-quoted.php constant.character.escape.hex.php

// Extracted from: should tokenize decoded one-digit hex escapes in quoted regexes
 "/\\x1Q600 \\x4Q/";
#  ^^       ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^       ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php
#         ^ string.regexp.double-quoted.php - constant.character.numeric.regexp.php

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 '/\x1Q600 \x4Q/';
#  ^^^     ^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#         ^ string.regexp.single-quoted.php - constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded one-digit hex escapes in quoted regexes
 '/\\x1Q600 \\x4Q/';
#  ^^       ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^       ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#         ^ string.regexp.single-quoted.php - constant.character.numeric.regexp.php

// Short \x across explicit hosts

// Extracted from: should tokenize raw short hex escapes in REGEX heredoc
<<<REGEX
 /\x/
# ^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Interpreted-host short \x in REGEX heredoc.
<<<REGEX
 /\\x/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Raw short \x in REGEXP nowdoc.
<<<'REGEXP'
  /\x/
#  ^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
REGEXP;

// Doubled short \x in REGEXP nowdoc.
<<<'REGEXP'
  /\\x/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// One-digit \xN across explicit hosts

// Raw one-digit \xN in REGEX heredoc.
<<<REGEX
 /\x1Q600 \x4Q/
# ^^^     ^^^ string.regexp.heredoc.php constant.character.escape.hex.php
REGEX;

// Extracted from: should tokenize one-digit hex escapes in REGEX heredoc
<<<REGEX
 /\\x1Q600 \\x4Q/
# ^^       ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^^       ^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
#        ^ string.regexp.heredoc.php - constant.character.numeric.regexp.php
REGEX;

// Extracted from: should tokenize one-digit hex escapes in REGEXP nowdoc
<<<'REGEXP'
  /\x1Q600 \x4Q/
#  ^^^     ^^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
#         ^ string.regexp.nowdoc.php - constant.character.numeric.regexp.php
REGEXP;

// Doubled one-digit \xN in REGEXP nowdoc.
<<<'REGEXP'
  /\\x1Q600 \\x4Q/
#  ^^       ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;
