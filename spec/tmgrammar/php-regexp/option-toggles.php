# SYNTAX TEST "source.php" "regex option toggles"
<?php

// Extracted from: should tokenize option toggles in REGEX heredoc
<<<REGEX
 /(?imsxADJUXunr-)/
# ^              ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.other.option-toggle.regexp.php
REGEX;

// Extracted from: should tokenize option toggles in REGEXP nowdoc
<<<'REGEXP'
 /(?imsxADJUXunr-)/
# ^              ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.other.option-toggle.regexp.php
REGEXP;
