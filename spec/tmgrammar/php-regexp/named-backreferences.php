# SYNTAX TEST "source.php" "regex named backreferences"
<?php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 "/\k<name>/";
#  ^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 '/\k<name>/';
#  ^^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 "/(?P=name)/";
#  ^       ^ string.regexp.double-quoted.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^ string.regexp.double-quoted.php meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php
#      ^^^^ string.regexp.double-quoted.php meta.embedded.group.regexp.php variable.other.regexp.php

// Extracted from: should tokenize angle named groups and classic named backreferences in quoted regexes
 '/(?P=name)/';
#  ^       ^ string.regexp.single-quoted.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^ string.regexp.single-quoted.php meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php
#      ^^^^ string.regexp.single-quoted.php meta.embedded.group.regexp.php variable.other.regexp.php

// Extracted from: should tokenize braced named backreferences in quoted regexes
 "/\k{name}/";
#  ^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize braced named backreferences in quoted regexes
 '/\k{name}/';
#  ^^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize braced named backreferences in quoted regexes
 "/\g{name}/";
#  ^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize braced named backreferences in quoted regexes
 '/\g{name}/';
#  ^^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize decoded named backreferences in interpreted quoted regexes
 "/\\k<name>/";
#  ^^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize decoded named backreferences in interpreted quoted regexes
 '/\\k<name>/';
#  ^^^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize decoded named backreferences in interpreted quoted regexes
 "/\\k'name'/";
#  ^^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: tokenizes decoded apostrophe-delimited named backreferences in single quoted regexes
 '/\\k\'name\'/';
#  ^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^^ string.regexp.single-quoted.php constant.character.escape.php punctuation.definition.group.capture.begin.regexp.php
#       ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
#           ^^ string.regexp.single-quoted.php constant.character.escape.php punctuation.definition.group.capture.end.regexp.php

// Extracted from: should tokenize decoded braced named backreferences in interpreted quoted regexes
 "/\\k{name}/";
#  ^^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize decoded braced named backreferences in interpreted quoted regexes
 '/\\k{name}/';
#  ^^^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize decoded braced named backreferences in interpreted quoted regexes
 "/\\g{name}/";
#  ^^^^^^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.double-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.double-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize decoded braced named backreferences in interpreted quoted regexes
 '/\\g{name}/';
#  ^^^^^^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php
#  ^^ string.regexp.single-quoted.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#     ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#          ^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#      ^^^^ string.regexp.single-quoted.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php

// Extracted from: should tokenize the full raw named backreference surface in REGEXP nowdoc
<<<'REGEXP'
 /\k<word>/
# ^^^^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#        ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw named backreference surface in REGEXP nowdoc
<<<'REGEXP'
 /\k'word'/
# ^^^^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#        ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw named backreference surface in REGEXP nowdoc
<<<'REGEXP'
 /(?P=word)/
# ^       ^ string.regexp.nowdoc.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ string.regexp.nowdoc.php meta.embedded.group.regexp.php keyword.other.back-reference.named.regexp.php
#     ^^^^ string.regexp.nowdoc.php meta.embedded.group.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw named backreference surface in REGEXP nowdoc
<<<'REGEXP'
 /\k{word}/
# ^^^^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#        ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should tokenize the full raw named backreference surface in REGEXP nowdoc
<<<'REGEXP'
 /\g{word}/
# ^^^^^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php
#   ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#        ^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#    ^^^^ string.regexp.nowdoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should tokenize decoded named backreferences in REGEX heredoc
<<<REGEX
 /\\k<word>/
# ^^^^^^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should tokenize decoded named backreferences in REGEX heredoc
<<<REGEX
 /\\k'word'/
# ^^^^^^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should tokenize decoded braced and g-style backreferences in REGEX heredoc
<<<REGEX
 /\\k{word}/
# ^^^^^^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should tokenize decoded braced and g-style backreferences in REGEX heredoc
<<<REGEX
 /\\g{word}/
# ^^^^^^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php
# ^^ string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.named.regexp.php
#    ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.begin.regexp.php
#         ^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php punctuation.definition.group.capture.end.regexp.php
#     ^^^^ string.regexp.heredoc.php keyword.other.back-reference.named.regexp.php variable.other.regexp.php
REGEX;
