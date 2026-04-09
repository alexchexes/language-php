# SYNTAX TEST "source.php" "regex character-class odd-parity literalized payloads"
<?php

// Three backslashes before non-PHP-owned payloads

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[\\\h \\\i \\\d \\\p]/";
#  ^                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^   ^^   ^^   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#     ^    ^    ^    ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^    ^    ^    ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

 "/[\\\; \\\c]/";
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#     ^    ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^    ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[\\\h \\\i \\\d \\\p]/';
#  ^                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^   ^^   ^^   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#     ^    ^    ^    ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^    ^    ^    ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

 '/[\\\; \\\c]/';
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#     ^    ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^    ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[\\\h \\\i \\\d \\\p]/
#  ^                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^   ^^   ^^   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#     ^    ^    ^    ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^    ^    ^    ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php
  /[\\\; \\\c]/
#  ^         ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^   ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#     ^    ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^    ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;

// Seven backslashes before non-PHP-owned payloads

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 "/[\\\\\\\h \\\\\\\i \\\\\\\d \\\\\\\p]/";
#  ^                                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^  ^^   ^^  ^^   ^^  ^^   ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#   ^^  ^^   ^^  ^^   ^^  ^^   ^^  ^^ - constant.character.escape.regexp.php
#     ^^       ^^       ^^       ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#         ^        ^        ^        ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^        ^        ^        ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

 "/[\\\\\\\; \\\\\\\c]/";
#  ^                 ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^  ^^   ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php - constant.character.escape.regexp.php
#     ^^       ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#         ^        ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^        ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes
 '/[\\\\\\\h \\\\\\\i \\\\\\\d \\\\\\\p]/';
#  ^                                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^  ^^   ^^  ^^   ^^  ^^   ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#   ^^  ^^   ^^  ^^   ^^  ^^   ^^  ^^ - constant.character.escape.regexp.php
#     ^^       ^^       ^^       ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#         ^        ^        ^        ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^        ^        ^        ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

 '/[\\\\\\\; \\\\\\\c]/';
#  ^                 ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^  ^^   ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php - constant.character.escape.regexp.php
#     ^^       ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#         ^        ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^        ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php

// Extracted from: should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes
<<<REGEX
  /[\\\\\\\h \\\\\\\i \\\\\\\d \\\\\\\p]/
#  ^                                   ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^  ^^   ^^  ^^   ^^  ^^   ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php
#   ^^  ^^   ^^  ^^   ^^  ^^   ^^  ^^ - constant.character.escape.regexp.php
#     ^^       ^^       ^^       ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#         ^        ^        ^        ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^        ^        ^        ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php
  /[\\\\\\\; \\\\\\\c]/
#  ^                 ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^^  ^^   ^^  ^^ constant.other.character-class.set.regexp.php constant.character.escape.php - constant.character.escape.regexp.php
#     ^^       ^^ constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#         ^        ^ constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#          ^        ^ - constant.character.escape.php constant.character.escape.regexp.php constant.character.class.regexp.php
REGEX;
