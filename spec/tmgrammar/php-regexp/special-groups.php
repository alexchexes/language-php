# SYNTAX TEST "source.php" "regex special groups"
<?php

// Atomic groups

// Extracted from: should tokenize atomic and branch-reset groups in quoted regexes
 "/(?>ab)/";
#  ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ punctuation.definition.group.atomic.regexp.php
#     ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize atomic and branch-reset groups in quoted regexes
 '/(?>ab)/';
#  ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ punctuation.definition.group.atomic.regexp.php
#     ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize atomic groups in REGEX heredoc
<<<REGEX
 /(?>ab)/
# ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.atomic.regexp.php
#    ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize atomic groups in REGEXP nowdoc
<<<'REGEXP'
 /(?>ab)/
# ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.atomic.regexp.php
#    ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize atomic and branch-reset groups in quoted regexes
 "/(*atomic:cd)/";
#  ^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^ punctuation.definition.group.atomic.regexp.php
#           ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize atomic and branch-reset groups in quoted regexes
 '/(*atomic:cd)/';
#  ^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^ punctuation.definition.group.atomic.regexp.php
#           ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize atomic groups in REGEX heredoc
<<<REGEX
 /(*atomic:cd)/
# ^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^ punctuation.definition.group.atomic.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize atomic groups in REGEXP nowdoc
<<<'REGEXP'
 /(*atomic:cd)/
# ^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^ punctuation.definition.group.atomic.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Branch-reset groups

// Extracted from: should tokenize atomic and branch-reset groups in quoted regexes
 "/(?|ef)/";
#  ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ punctuation.definition.group.branch-reset.regexp.php
#     ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize atomic and branch-reset groups in quoted regexes
 '/(?|ef)/';
#  ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ punctuation.definition.group.branch-reset.regexp.php
#     ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize branch-reset groups in REGEX heredoc
<<<REGEX
 /(?|ab)/
# ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.branch-reset.regexp.php
#    ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize branch-reset groups in REGEXP nowdoc
<<<'REGEXP'
 /(?|ab)/
# ^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.branch-reset.regexp.php
#    ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Script-run groups

// Extracted from: should tokenize script-run groups in quoted regexes
 "/(*sr:ab)/";
#  ^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^ punctuation.definition.group.script-run.regexp.php
#       ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize script-run groups in quoted regexes
 '/(*sr:ab)/';
#  ^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^ punctuation.definition.group.script-run.regexp.php
#       ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize script-run groups in REGEX heredoc
<<<REGEX
 /(*sr:ab)/
# ^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^ punctuation.definition.group.script-run.regexp.php
#      ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize script-run groups in REGEXP nowdoc
<<<'REGEXP'
 /(*sr:ab)/
# ^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^ punctuation.definition.group.script-run.regexp.php
#      ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize script-run groups in quoted regexes
 "/(*script_run:cd)/";
#  ^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^ punctuation.definition.group.script-run.regexp.php
#               ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize script-run groups in quoted regexes
 '/(*script_run:cd)/';
#  ^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^ punctuation.definition.group.script-run.regexp.php
#               ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize script-run groups in REGEX heredoc
<<<REGEX
 /(*script_run:cd)/
# ^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^ punctuation.definition.group.script-run.regexp.php
#              ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize script-run groups in REGEXP nowdoc
<<<'REGEXP'
 /(*script_run:cd)/
# ^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^ punctuation.definition.group.script-run.regexp.php
#              ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize script-run groups in quoted regexes
 "/(*asr:ef)/";
#  ^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#        ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize script-run groups in quoted regexes
 '/(*asr:ef)/';
#  ^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#        ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize script-run groups in REGEX heredoc
<<<REGEX
 /(*asr:ef)/
# ^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#       ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize script-run groups in REGEXP nowdoc
<<<'REGEXP'
 /(*asr:ef)/
# ^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#       ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize script-run groups in quoted regexes
 "/(*atomic_script_run:gh)/";
#  ^^^^^^^^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#                      ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize script-run groups in quoted regexes
 '/(*atomic_script_run:gh)/';
#  ^^^^^^^^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#                      ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize script-run groups in REGEX heredoc
<<<REGEX
 /(*atomic_script_run:gh)/
# ^^^^^^^^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#                     ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize script-run groups in REGEXP nowdoc
<<<'REGEXP'
 /(*atomic_script_run:gh)/
# ^^^^^^^^^^^^^^^^^^^^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^^ punctuation.definition.group.atomic-script-run.regexp.php
#                     ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;
