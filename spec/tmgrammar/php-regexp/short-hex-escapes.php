# SYNTAX TEST "source.php" "regex short hex escapes"
<?php

// Raw short hex in quoted hosts

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 "/\x/";
#  ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 '/\x/';
#  ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Interpreted-host transport for short hex

// Added to keep short-hex transport explicit in double quoted regexes.
 "/\\x/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.numeric.regexp.php

// Added to keep short-hex transport explicit in single quoted regexes.
 '/\\x/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^ string.regexp.single-quoted.php constant.character.numeric.regexp.php

// Raw one-digit short hex where PHP does not pre-consume the source spelling

// Extracted from: should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes
 '/\x1Q600 \x4Q/';
#  ^^^     ^^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#         ^ string.regexp.single-quoted.php - constant.character.numeric.regexp.php

// Interpreted-host transport for one-digit short hex

// Extracted from: should tokenize decoded one-digit hex escapes in quoted regexes
 "/\\x1Q600 \\x4Q/";
#  ^^       ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^       ^^ string.regexp.double-quoted.php constant.character.numeric.regexp.php
#         ^ string.regexp.double-quoted.php - constant.character.numeric.regexp.php

// Extracted from: should tokenize decoded one-digit hex escapes in quoted regexes
 '/\\x1Q600 \\x4Q/';
#  ^^       ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.numeric.regexp.php
#    ^^       ^^ string.regexp.single-quoted.php constant.character.numeric.regexp.php
#         ^ string.regexp.single-quoted.php - constant.character.numeric.regexp.php

// Raw short hex in explicit hosts

// Extracted from: should tokenize raw short hex escapes in REGEX heredoc
<<<REGEX
 /\x/
# ^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Added to keep short-hex transport explicit in REGEX heredoc.
<<<REGEX
 /\\x/
# ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^ string.regexp.heredoc.php constant.character.numeric.regexp.php
REGEX;

// Interpreted-host transport for one-digit short hex

// Extracted from: should tokenize one-digit hex escapes in REGEX heredoc
<<<REGEX
 /\\x1Q600 \\x4Q/
# ^^       ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#   ^^       ^^ string.regexp.heredoc.php constant.character.numeric.regexp.php
#        ^ string.regexp.heredoc.php - constant.character.numeric.regexp.php
REGEX;

// Raw nowdoc short hex and doubled-backslash contrasts

// Added to keep raw short-hex coverage explicit in REGEXP nowdoc.
<<<'REGEXP'
  /\x/
#  ^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
REGEXP;

// Added to show that doubled nowdoc backslashes stay regex-side, not PHP-side.
<<<'REGEXP'
  /\\x/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize one-digit hex escapes in REGEXP nowdoc
<<<'REGEXP'
  /\x1Q600 \x4Q/
#  ^^^     ^^^ string.regexp.nowdoc.php constant.character.numeric.regexp.php
#         ^ string.regexp.nowdoc.php - constant.character.numeric.regexp.php
REGEXP;

// Added to show that doubled nowdoc backslashes stay regex-side for one-digit forms too.
<<<'REGEXP'
  /\\x1Q600 \\x4Q/
#  ^^       ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Raw interpreted-host \x1... forms are intentionally omitted here:
// PHP consumes them as source-level hex escapes before regex tokenization.
