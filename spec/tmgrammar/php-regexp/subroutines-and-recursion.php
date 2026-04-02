# SYNTAX TEST "source.php" "regex subroutines and recursion"
<?php

// Group recursion and subroutine calls

// Extracted from: should tokenize recursion and subroutine calls in quoted regexes
 "/(?R)(?0)(?1)(?+1)(?-1)(?&word)(?P>word)/";
#  ^  ^^  ^^  ^^   ^^   ^^      ^^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^  ^^ keyword.other.recursion.regexp.php
#           ^   ^    ^ keyword.other.subroutine.regexp.php
#            ^   ^^   ^^ constant.numeric.regexp.php
#                         ^^      ^^^ keyword.other.subroutine.named.regexp.php
#                           ^^^^     ^^^^ variable.other.regexp.php

// Extracted from: should tokenize recursion and subroutine calls in quoted regexes
 '/(?R)(?0)(?1)(?+1)(?-1)(?&word)(?P>word)/';
#  ^  ^^  ^^  ^^   ^^   ^^      ^^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^  ^^ keyword.other.recursion.regexp.php
#           ^   ^    ^ keyword.other.subroutine.regexp.php
#            ^   ^^   ^^ constant.numeric.regexp.php
#                         ^^      ^^^ keyword.other.subroutine.named.regexp.php
#                           ^^^^     ^^^^ variable.other.regexp.php

// Extracted from: should tokenize recursion and subroutine calls in REGEX heredoc
<<<REGEX
 /(?R)(?0)(?1)(?+1)(?-1)(?&word)(?P>word)/
# ^  ^^  ^^  ^^   ^^   ^^      ^^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^  ^^ keyword.other.recursion.regexp.php
#          ^   ^    ^ keyword.other.subroutine.regexp.php
#           ^   ^^   ^^ constant.numeric.regexp.php
#                        ^^      ^^^ keyword.other.subroutine.named.regexp.php
#                          ^^^^     ^^^^ variable.other.regexp.php
REGEX;

// Extracted from: should tokenize recursion and subroutine calls in REGEXP nowdoc
<<<'REGEXP'
 /(?R)(?0)(?1)(?+1)(?-1)(?&word)(?P>word)/
# ^  ^^  ^^  ^^   ^^   ^^      ^^       ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^  ^^ keyword.other.recursion.regexp.php
#          ^   ^    ^ keyword.other.subroutine.regexp.php
#           ^   ^^   ^^ constant.numeric.regexp.php
#                        ^^      ^^^ keyword.other.subroutine.named.regexp.php
#                          ^^^^     ^^^^ variable.other.regexp.php
REGEXP;

// Oniguruma subroutine calls

// Extracted from: should tokenize recursion and subroutine calls in quoted regexes
 "/\g<word>\g'word'\g<1>\g<+1>\g'-1'/";
#  ^^      ^^ keyword.other.subroutine.named.regexp.php
#    ^       ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^    ^^^^ variable.other.regexp.php
#         ^       ^ punctuation.definition.group.capture.end.regexp.php
#                  ^^   ^^    ^^ keyword.other.subroutine.regexp.php
#                    ^    ^     ^ punctuation.definition.group.capture.begin.regexp.php
#                     ^    ^^    ^^ constant.numeric.regexp.php
#                      ^     ^     ^ punctuation.definition.group.capture.end.regexp.php

// Extracted from: should tokenize recursion and subroutine calls in quoted regexes
 '/\g<word>\g<1>\g<+1>\g<-1>/';
#  ^^^^^^^^ keyword.other.subroutine.named.regexp.php
#    ^       ^    ^     ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ variable.other.regexp.php
#         ^    ^     ^     ^ punctuation.definition.group.capture.end.regexp.php
#          ^^^^^^^^^^^^^^^^^ keyword.other.subroutine.regexp.php
#             ^    ^^    ^^ constant.numeric.regexp.php

// Extracted from: should tokenize decoded Oniguruma subroutine calls in interpreted quoted regexes
 "/\\g<word>\\g'word'\\g<1>\\g<+1>\\g'-1'/";
#  ^^       ^^ constant.character.escape.php keyword.other.subroutine.named.regexp.php
#    ^        ^ keyword.other.subroutine.named.regexp.php
#     ^        ^ punctuation.definition.group.capture.begin.regexp.php
#      ^^^^     ^^^^ variable.other.regexp.php
#          ^        ^ punctuation.definition.group.capture.end.regexp.php
#                    ^^    ^^     ^^ constant.character.escape.php keyword.other.subroutine.regexp.php
#                      ^     ^      ^ keyword.other.subroutine.regexp.php
#                       ^     ^      ^ punctuation.definition.group.capture.begin.regexp.php
#                        ^     ^^     ^^ constant.numeric.regexp.php
#                         ^      ^      ^ punctuation.definition.group.capture.end.regexp.php

// Extracted from: should tokenize decoded Oniguruma subroutine calls in interpreted quoted regexes
 '/\\g<word>\\g<1>\\g<+1>\\g<-1>/';
#  ^^ constant.character.escape.php keyword.other.subroutine.named.regexp.php
#    ^ keyword.other.subroutine.named.regexp.php
#     ^ punctuation.definition.group.capture.begin.regexp.php
#      ^^^^ variable.other.regexp.php
#          ^ punctuation.definition.group.capture.end.regexp.php
#           ^^    ^^     ^^ constant.character.escape.php keyword.other.subroutine.regexp.php
#             ^     ^      ^ keyword.other.subroutine.regexp.php
#              ^     ^      ^ punctuation.definition.group.capture.begin.regexp.php
#               ^     ^^     ^^ constant.numeric.regexp.php
#                ^      ^      ^ punctuation.definition.group.capture.end.regexp.php

// Extracted from: tokenizes apostrophe-delimited backreferences and subroutine calls in single quoted regex source
 '/\g\'word\'\g\'+1\'\g\'-1\'/';
#  ^^^^^^^^^^ keyword.other.subroutine.named.regexp.php
#    ^^        ^^      ^^ constant.character.escape.php punctuation.definition.group.capture.begin.regexp.php
#      ^^^^ variable.other.regexp.php
#          ^^      ^^      ^^ constant.character.escape.php punctuation.definition.group.capture.end.regexp.php
#            ^^^^^^^^^^^^^^^^ keyword.other.subroutine.regexp.php
#                ^^      ^^ constant.numeric.regexp.php

// Extracted from: tokenizes decoded apostrophe-delimited Oniguruma subroutine calls in single quoted regexes
 '/\\g\'word\'\\g\'+1\'\\g\'-1\'/';
#  ^^ constant.character.escape.php keyword.other.subroutine.named.regexp.php
#    ^ keyword.other.subroutine.named.regexp.php
#     ^^         ^^       ^^ constant.character.escape.php punctuation.definition.group.capture.begin.regexp.php
#       ^^^^ variable.other.regexp.php
#           ^^       ^^       ^^ constant.character.escape.php punctuation.definition.group.capture.end.regexp.php
#             ^^       ^^ constant.character.escape.php keyword.other.subroutine.regexp.php
#               ^        ^ keyword.other.subroutine.regexp.php
#                  ^^       ^^ constant.numeric.regexp.php

// Extracted from: should tokenize decoded Oniguruma subroutine calls in REGEX heredoc
<<<REGEX
 /\\g<word>\\g'word'\\g<1>\\g<+1>\\g'-1'/
# ^^       ^^ constant.character.escape.php keyword.other.subroutine.named.regexp.php
#   ^        ^ keyword.other.subroutine.named.regexp.php
#    ^        ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^     ^^^^ variable.other.regexp.php
#         ^        ^ punctuation.definition.group.capture.end.regexp.php
#                   ^^    ^^     ^^ constant.character.escape.php keyword.other.subroutine.regexp.php
#                     ^     ^      ^ keyword.other.subroutine.regexp.php
#                      ^     ^      ^ punctuation.definition.group.capture.begin.regexp.php
#                       ^     ^^     ^^ constant.numeric.regexp.php
#                        ^      ^      ^ punctuation.definition.group.capture.end.regexp.php
REGEX;

// Extracted from: should tokenize the full raw \g numeric backreference and subroutine surface in REGEXP nowdoc
<<<'REGEXP'
 /\g<word>\g'word'\g<1>\g<+1>\g'-1'/
# ^^      ^^ keyword.other.subroutine.named.regexp.php
#   ^       ^ punctuation.definition.group.capture.begin.regexp.php
#    ^^^^    ^^^^ variable.other.regexp.php
#        ^       ^ punctuation.definition.group.capture.end.regexp.php
#                 ^^   ^^    ^^ keyword.other.subroutine.regexp.php
#                   ^    ^     ^ punctuation.definition.group.capture.begin.regexp.php
#                    ^    ^^    ^^ constant.numeric.regexp.php
#                     ^     ^     ^ punctuation.definition.group.capture.end.regexp.php
REGEXP;
