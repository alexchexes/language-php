# SYNTAX TEST "source.php" "regex raw named backreferences"
<?php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 '/(?<name>ab)\k<name>(?P=name)/';
#  ^^^    ^  ^        ^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^          ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^                ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#         ^          ^ punctuation.definition.group.capture.end.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#             ^^^^^^^^ keyword.other.back-reference.named.regexp.php
#                ^^^^ variable.other.regexp.php
#                      ^^^ meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 "/(?<name>ab)\k<name>(?P=name)/";
#  ^^^    ^  ^        ^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^          ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^                ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#         ^          ^ punctuation.definition.group.capture.end.regexp.php
#          ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#             ^^^^^^^^ keyword.other.back-reference.named.regexp.php
#                ^^^^ variable.other.regexp.php
#                      ^^^ meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php

// Extracted from: should tokenize braced named backreferences in quoted regexes
 '/\k{name}\g{name}/';
#  ^^^^^^^^^^^^^^^^ keyword.other.back-reference.named.regexp.php
#    ^       ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^    ^^^^ variable.other.regexp.php
#         ^       ^ punctuation.definition.group.capture.end.regexp.php

// Extracted from: should tokenize braced named backreferences in quoted regexes
 "/\k{name}\g{name}/";
#  ^^^^^^^^^^^^^^^^ keyword.other.back-reference.named.regexp.php
#    ^       ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^    ^^^^ variable.other.regexp.php
#         ^       ^ punctuation.definition.group.capture.end.regexp.php

// Extracted from: should tokenize backreferences in REGEX heredoc
<<<REGEX
 /\\k<word>\\k'word'(?P=word)/
# ^^       ^^ constant.character.escape.php keyword.other.back-reference.named.regexp.php
#   ^^^^^^^  ^^^^^^^ keyword.other.back-reference.named.regexp.php
#    ^        ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^     ^^^^ variable.other.regexp.php
#         ^        ^ punctuation.definition.group.capture.end.regexp.php
#                   ^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#                    ^^^ meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php
#                       ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should tokenize backreferences in REGEXP nowdoc
<<<'REGEXP'
 /\k<word>\k'word'(?P=word)/
# ^^^^^^^^^^^^^^^^ keyword.other.back-reference.named.regexp.php
#   ^       ^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^    ^^^^ variable.other.regexp.php
#        ^       ^ punctuation.definition.group.capture.end.regexp.php
#                 ^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#                  ^^^ meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php
#                     ^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should tokenize braced and g-style backreferences in REGEX heredoc
<<<REGEX
 /\\k{word}\\g{word}/
# ^^       ^^ constant.character.escape.php keyword.other.back-reference.named.regexp.php
#   ^^^^^^^  ^^^^^^^ keyword.other.back-reference.named.regexp.php
#    ^        ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^     ^^^^ variable.other.regexp.php
#         ^        ^ punctuation.definition.group.capture.end.regexp.php
REGEX;

// Extracted from: should tokenize braced and g-style backreferences in REGEXP nowdoc
<<<'REGEXP'
 /\k{word}\g{word}/
# ^^^^^^^^^^^^^^^^ keyword.other.back-reference.named.regexp.php
#   ^       ^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^    ^^^^ variable.other.regexp.php
#        ^       ^ punctuation.definition.group.capture.end.regexp.php
REGEXP;
