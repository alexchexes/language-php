# SYNTAX TEST "source.php" "regex explicit character-class odd-parity literalized payloads"
<?php

// Three interpreted backslashes

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\h]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\i]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\d]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\p]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\;]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\c]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Seven interpreted backslashes

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\h]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#        ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\i]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#        ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\d]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#        ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\p]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#        ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\;]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#        ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[a\\\\\\\c]/
#    ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#      ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#        ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#          ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#           ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;
