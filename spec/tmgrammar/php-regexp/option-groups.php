# SYNTAX TEST "source.php" "regex option groups"
<?php

// Extracted from: should tokenize full option-group payloads in quoted regexes
 "/(?im-sxADJUXunr:ab)/";
#  ^                 ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^             ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.option.regexp.php
#    ^^^^^^^^^^^^^ meta.embedded.group.regexp.php storage.modifier.regexp.php
#                  ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize full option-group payloads in quoted regexes
 '/(?im-sxADJUXunr:ab)/';
#  ^                 ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^             ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.option.regexp.php
#    ^^^^^^^^^^^^^ meta.embedded.group.regexp.php storage.modifier.regexp.php
#                  ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize option groups in REGEX heredoc
<<<REGEX
 /(?im-sxADJUXunr:ab)/
# ^                 ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^             ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.option.regexp.php
#   ^^^^^^^^^^^^^ meta.embedded.group.regexp.php storage.modifier.regexp.php
#                 ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize option groups in REGEXP nowdoc
<<<'REGEXP'
 /(?im-sxADJUXunr:ab)/
# ^                 ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^             ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.option.regexp.php
#   ^^^^^^^^^^^^^ meta.embedded.group.regexp.php storage.modifier.regexp.php
#                 ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;
