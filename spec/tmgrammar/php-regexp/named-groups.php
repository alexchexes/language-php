# SYNTAX TEST "source.php" "regex named groups"
<?php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 "/(?<name>ab)/";
#  ^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#         ^ punctuation.definition.group.capture.end.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 '/(?<name>ab)/';
#  ^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#         ^ punctuation.definition.group.capture.end.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php

// Extracted from: should tokenize angle-bracket named groups in REGEX heredoc
<<<REGEX
 /(?<word>ab)/
# ^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#        ^ punctuation.definition.group.capture.end.regexp.php
#         ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize angle-bracket named groups in REGEXP nowdoc
<<<'REGEXP'
 /(?<word>ab)/
# ^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#        ^ punctuation.definition.group.capture.end.regexp.php
#         ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize single-quoted named groups in REGEXP heredoc
<<<REGEXP
 /(?'word'ab)/
# ^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#        ^ punctuation.definition.group.capture.end.regexp.php
#         ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEXP;

// Extracted from: should tokenize PCRE named groups in REGEXP heredoc
<<<REGEXP
 /(?P<word>ab)/
# ^^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#         ^ punctuation.definition.group.capture.end.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEXP;

// Extracted from: should tokenize single-quoted and PCRE named groups in REGEXP nowdoc
<<<'REGEXP'
 /(?'word'ab)/
# ^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#        ^ punctuation.definition.group.capture.end.regexp.php
#         ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize single-quoted and PCRE named groups in REGEXP nowdoc
<<<'REGEXP'
 /(?P<word>ab)/
# ^^^^    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#         ^ punctuation.definition.group.capture.end.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;
