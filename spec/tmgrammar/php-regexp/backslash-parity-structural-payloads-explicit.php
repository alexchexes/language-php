# SYNTAX TEST "source.php" "regex explicit character-class backslash parity for structural payloads"
<?php

// POSIX classes

// Extracted from: should keep interpreted backslash parity consistent before POSIX character classes in REGEX heredoc character classes
<<<REGEX
  /[\[:digit:]]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should keep interpreted backslash parity consistent before POSIX character classes in REGEX heredoc character classes
<<<REGEX
  /[\\[:digit:]]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
REGEX;

// Extracted from: should keep interpreted backslash parity consistent before POSIX character classes in REGEX heredoc character classes
<<<REGEX
  /[\\\[:digit:]]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^^ meta.embedded.character-class.posix.regexp.php punctuation.definition.character-class.set.begin.regexp.php
#        ^^^^^ meta.embedded.character-class.posix.regexp.php constant.other.character-class.posix.regexp.php
#             ^^ meta.embedded.character-class.posix.regexp.php punctuation.definition.character-class.set.end.regexp.php
REGEX;

// Extracted from: should keep interpreted backslash parity consistent before POSIX character classes in REGEX heredoc character classes
<<<REGEX
  /[\\\\[:digit:]]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^^ meta.embedded.character-class.posix.regexp.php punctuation.definition.character-class.set.begin.regexp.php
#         ^^^^^ meta.embedded.character-class.posix.regexp.php constant.other.character-class.posix.regexp.php
#              ^^ meta.embedded.character-class.posix.regexp.php punctuation.definition.character-class.set.end.regexp.php
REGEX;

// Direct closing bracket

// Extracted from: should keep direct closing-bracket backslash parity consistent in REGEX heredoc character classes
<<<REGEX
  /[\]a]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#     ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#      ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEX;

// Extracted from: should keep direct closing-bracket backslash parity consistent in REGEX heredoc character classes
<<<REGEX
  /[\\]a]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEX;

// Extracted from: should keep direct closing-bracket backslash parity consistent in REGEX heredoc character classes
<<<REGEX
  /[\\\]a]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#      ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#       ^^^ string.regexp.heredoc.php
REGEX;

// Extracted from: should keep direct closing-bracket backslash parity consistent in REGEX heredoc character classes
<<<REGEX
  /[\\\\]a]/
#   ^^ meta.embedded.character-class.regexp.php constant.character.escape.php
#     ^^ meta.embedded.character-class.regexp.php constant.character.escape.regexp.php
#       ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#        ^^^ string.regexp.heredoc.php
REGEX;
