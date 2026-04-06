# SYNTAX TEST "source.php" "regex neutral punctuation escapes"
<?php

// Interpreted hosts

// Extracted from: should tokenize neutral non-alnum punctuation escapes according to PHP host rules
 "/\;/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize neutral non-alnum punctuation escapes according to PHP host rules
 "/\\;/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.double-quoted.php constant.character.escape.regexp.php

// Extracted from: should decompose repeated interpreted backslashes before neutral punctuation in quoted regexes
 "/\\\\;/";
#  ^^ string.regexp.double-quoted.php constant.character.escape.php - constant.character.escape.regexp.php
#    ^^ string.regexp.double-quoted.php constant.character.escape.php constant.character.escape.regexp.php

// Extracted from: should tokenize neutral non-alnum punctuation escapes according to PHP host rules
 '/\;/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Extracted from: should tokenize neutral non-alnum punctuation escapes according to PHP host rules
 '/\\;/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.single-quoted.php constant.character.escape.regexp.php

// Extracted from: should decompose repeated interpreted backslashes before neutral punctuation in quoted regexes
 '/\\\\;/';
#  ^^ string.regexp.single-quoted.php constant.character.escape.php - constant.character.escape.regexp.php
#    ^^ string.regexp.single-quoted.php constant.character.escape.php constant.character.escape.regexp.php

// Extracted from: should tokenize neutral non-alnum punctuation escapes in REGEX heredoc
<<<REGEX
  /\;/
#  ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize neutral non-alnum punctuation escapes in REGEX heredoc
<<<REGEX
  /\\;/
#  ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#    ^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should decompose repeated interpreted backslashes before neutral punctuation in REGEX heredoc
<<<REGEX
  /\\\\;/
#  ^^ string.regexp.heredoc.php constant.character.escape.php - constant.character.escape.regexp.php
#    ^^ string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
REGEX;

// Raw host

// Extracted from: should tokenize neutral non-alnum punctuation escapes in REGEXP nowdoc
<<<'REGEXP'
  /\;/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize neutral non-alnum punctuation escapes in REGEXP nowdoc
<<<'REGEXP'
  /\\;/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
#    ^ string.regexp.nowdoc.php - constant.character.escape.regexp.php
REGEXP;
