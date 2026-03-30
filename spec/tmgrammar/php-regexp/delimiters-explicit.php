# SYNTAX TEST "source.php" "explicit regex delimiters"
<?php

// Extracted from: should tokenize escaped `[` in REGEX heredoc
// Escaped bracket in REGEX heredoc.
<<<REGEX
  /\[/
#  ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize doubled class backslashes in REGEX nowdoc
// Doubled class backslashes in REGEX nowdoc.
<<<'REGEX'
  /[\\\\]/
#  ^    ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^ string.regexp.character-class.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize escaped `[` in REGEX nowdoc
// Escaped bracket in REGEX nowdoc.
<<<'REGEX'
  /\[/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize escaped `[` in REGEXP heredoc
// Escaped bracket in REGEXP heredoc.
<<<REGEXP
  /\[/
#  ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize doubled class backslashes in REGEXP nowdoc
// Doubled class backslashes in REGEXP nowdoc.
<<<'REGEXP'
  /[\\\\]/
#  ^    ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^ string.regexp.character-class.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize escaped `[` in REGEXP nowdoc
// Escaped bracket in REGEXP nowdoc.
<<<'REGEXP'
  /\[/
#  ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;

// Extracted from: should tokenize escaped slashes in REGEX heredoc
// Escaped slash stays inside the regex body instead of ending it.
<<<REGEX
  foo/bar\/baz
#        ^^ string.regexp.heredoc.php constant.character.escape.regexp.php
REGEX;

// Extracted from: should tokenize escaped slashes in REGEXP nowdoc
<<<'REGEXP'
  foo/bar\/baz
#        ^^ string.regexp.nowdoc.php constant.character.escape.regexp.php
REGEXP;
