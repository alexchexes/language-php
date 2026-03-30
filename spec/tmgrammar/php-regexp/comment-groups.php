# SYNTAX TEST "source.php" "regex comment groups"
<?php

// Extracted from: should tokenize comment groups in quoted regex strings
 "/(?# note)/";
#  ^^^ string.regexp.double-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.double-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.double-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php

// Extracted from: should tokenize comment groups in quoted regex strings
 '/(?# note)/';
#  ^^^ string.regexp.single-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.single-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.single-quoted.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php

// Extracted from: should tokenize comment groups in REGEX heredoc
<<<REGEX
  /(?# note)/
#  ^^^ string.regexp.heredoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.heredoc.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.heredoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php
REGEX;

// Extracted from: should tokenize comment groups in REGEXP nowdoc
<<<'REGEXP'
  /(?# note)/
#  ^^^ string.regexp.nowdoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.begin.regexp.php
#     ^^^^^ string.regexp.nowdoc.php meta.embedded.group.regexp.php comment.block.regexp.php
#          ^ string.regexp.nowdoc.php meta.embedded.group.regexp.php comment.block.regexp.php punctuation.definition.comment.end.regexp.php
REGEXP;
