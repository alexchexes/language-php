# SYNTAX TEST "source.php" "regex character-class odd-parity literalized payloads"
<?php

// Three backslashes before non-PHP-owned payloads

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\h]/";
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\i]/";
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\d]/";
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\p]/";
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\;]/";
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\c]/";
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\h]/';
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\i]/';
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\d]/';
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\p]/';
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\;]/';
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\c]/';
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\h]/
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\i]/
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\d]/
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\p]/
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\;]/
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\c]/
#    ^^ string.regexp.character-class.php constant.character.escape.php
#      ^ string.regexp.character-class.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Seven backslashes before non-PHP-owned payloads

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\\\\\h]/";
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\\\\\i]/";
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\\\\\d]/";
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\\\\\p]/";
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\\\\\;]/";
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[a\\\\\\\c]/";
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\\\\\h]/';
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\\\\\i]/';
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\\\\\d]/';
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\\\\\p]/';
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\\\\\;]/';
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[a\\\\\\\c]/';
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^ string.regexp.character-class.php constant.character.escape.php constant.character.escape.regexp.php
#          ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\h]/
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^  ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\i]/
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^  ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\d]/
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^  ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\p]/
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^  ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\;]/
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^  ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\c]/
#    ^^  ^^ string.regexp.character-class.php constant.character.escape.php
#      ^^  ^ string.regexp.character-class.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#           ^ - constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;
