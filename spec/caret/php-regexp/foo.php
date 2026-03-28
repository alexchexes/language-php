<?php

$r = <<<REGEX
\1            \x21             \u{21}
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.octal.php
#^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.octal.php
# ^^^^^^^^^^^^    ^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#             ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.hex.php
#                              ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.unicode.php
\n            \v               \$
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#^            ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
# ^^^^^^^^^^^^  ^^^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                              ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php keyword.control.anchor.regexp.php
[\1-\3]       [\x21-\x43]      [\u{21}-\u{43}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.octal.php
#  ^               ^                  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#     ^       ^         ^      ^             ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#      ^^^^^^^           ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#              ^^^^ ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.hex.php
#                               ^^^^^^ ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.unicode.php
[\n-\t]       [\v]             [\$-\^]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ ^^         ^^               ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^                              ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#     ^       ^  ^             ^     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#      ^^^^^^^    ^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                                  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php

\\1           \\x21            \\u{21}
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.regexp.php
#^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php keyword.other.back-reference.regexp.php
# ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.other.back-reference.regexp.php constant.numeric.regexp.php
#  ^^^^^^^^^^^     ^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#             ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#               ^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.numeric.regexp.php
#                              ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php invalid.illegal.escape.regexp.php
#                                ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php invalid.illegal.escape.regexp.php
#                                 ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php punctuation.definition.quantifier.begin.regexp.php
#                                  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#                                    ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php punctuation.definition.quantifier.end.regexp.php
\\n           \\v              \\$
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#^                             ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
# ^                              ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
#  ^^^^^^^^^^^   ^^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#             ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
#               ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.regexp.php
[\\1-\\3]     [\\x21-\\x43]    [\\u{21}-\\u{43}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.numeric.octal.regexp.php
#  ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.octal.regexp.php
#   ^               ^                  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^     ^           ^    ^               ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#        ^^^^^             ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#              ^^    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.numeric.regexp.php
#                ^^^   ^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#                               ^^      ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php invalid.illegal.escape.regexp.php
#                                 ^       ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php invalid.illegal.escape.regexp.php
#                                  ^  ^    ^  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#                                   ^^      ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.regexp.php
[\\n-\\t]     [\\v]            [\\$-\\^]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^  ^^                         ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#  ^   ^                          ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#   ^                              ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^     ^   ^            ^       ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#        ^^^^^     ^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#              ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.class.regexp.php
#                ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#                                   ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#                                     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php

\\\1          \\\x21           \\\u{21}
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#^            ^^               ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
# ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.octal.php
#   ^^^^^^^^^^      ^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#               ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.hex.php
#                                ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.unicode.php
\\\n          \\\v             \\\$
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#^^^          ^^^^             ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#   ^^^^^^^^^^    ^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
[\\\1-\\\3]   [\\\x21-\\\x43]  [\\\u{21}-\\\u{43}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^   ^^       ^^     ^^        ^^       ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^   ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.octal.php
#    ^               ^                  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#         ^   ^             ^  ^                 ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#          ^^^               ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                ^^^^   ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.hex.php
#                                 ^^^^^^   ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.unicode.php
[\\\n-\\\t]   [\\\v]           [\\\$-\\\^]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^^^ ^^^^     ^^^^             ^^^^ ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#    ^                              ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#         ^   ^    ^           ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#          ^^^      ^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                                      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#                                       ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php

\  \\  \/  \\\  \\/
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#^^  ^^  ^^   ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#      ^^    ^    ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
#          ^^   ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php

\.        \(?:a)        \[a]          \{1}        \*        \+        \?        \^        \|
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
#^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
# ^^^^^^^^   ^^^^^^^^^^^  ^^^^^^^^^^^^  ^^^^^^^^^^  ^^^^^^^^  ^^^^^^^^  ^^^^^^^^  ^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#           ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
\\.       \\(?:a)       \\[a-z]       \\{1}       \\*       \\+       \\?       \\^       \\|
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
# ^         ^             ^             ^           ^         ^         ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
#  ^^^^^^^    ^^^^^^^^^^   ^^^^^^^^^^^   ^^^^^^^^^   ^^^^^^^   ^^^^^^^   ^^^^^^^   ^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#            ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
\\\.      \\\(?:a)      \\\[a-z]      \\\{1}      \\\*      \\\+      \\\?      \\\^      \\\|
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
# ^         ^             ^             ^           ^         ^         ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
#  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.wildcard.regexp.php
#   ^^^^^^        ^^^^^^        ^^^^^^      ^^^^^^    ^^^^^^    ^^^^^^    ^^^^^^    ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#            ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#             ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
#               ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.group.regexp.php string.regexp.heredoc.php
#                          ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#                           ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#                            ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#                                        ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php punctuation.definition.quantifier.begin.regexp.php
#                                         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#                                          ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php punctuation.definition.quantifier.end.regexp.php
#                                                    ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
#                                                                                  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.control.anchor.regexp.php
#                                                                                            ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.or.regexp.php
\\\\.     \\\\(?:a)     \\\\[a-z]     \\\\{1}     \\\\*     \\\\+     \\\\?     \\\\^     \\\\|
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
# ^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.wildcard.regexp.php
#    ^^^^^         ^^^^^         ^^^^^       ^^^^^     ^^^^^     ^^^^^     ^^^^^     ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#             ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#              ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
#                ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.group.regexp.php string.regexp.heredoc.php
#                           ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#                            ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#                             ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#                                         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php punctuation.definition.quantifier.begin.regexp.php
#                                          ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php
#                                           ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.quantifier.range.regexp.php keyword.operator.quantifier.regexp.php punctuation.definition.quantifier.end.regexp.php
#                                                     ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.quantifier.regexp.php
#                                                                                   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.control.anchor.regexp.php
#                                                                                             ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.or.regexp.php
\\\\\.    \\\\\(?:a)    \\\\\[a-z]    \\\\\{1}    \\\\\*    \\\\\+    \\\\\?    \\\\\^    \\\\\|
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
#^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php
# ^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.escape.regexp.php
#   ^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.regexp.php
#     ^^^^       ^^^^^^^      ^^^^^^^^      ^^^^^^      ^^^^      ^^^^      ^^^^      ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#               ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php keyword.operator.quantifier.regexp.php

[\.]      [\(?:a)]      [\[a]]        [\{1}]      [\*]      [\+]      [\?]      [\^]      [\|]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#  ^      ^      ^      ^   ^         ^    ^      ^  ^      ^  ^      ^  ^      ^  ^      ^  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^^^        ^^^^^^     ^^^^^^^^^      ^^^^^^    ^^^^^^    ^^^^^^    ^^^^^^    ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#            ^^^^          ^              ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#                                        ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.regexp.php
[\\.]     [\\(?:a)]     [\\[a-z]]     [\\{1}]     [\\*]     [\\+]     [\\?]     [\\^]     [\\|]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^         ^^^^^         ^             ^ ^         ^         ^         ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#   ^     ^       ^     ^      ^      ^     ^     ^   ^     ^   ^     ^   ^     ^   ^     ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#    ^^^^^         ^^^^^        ^^^^^^       ^^^^^     ^^^^^     ^^^^^     ^^^^^     ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                           ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#                            ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#                                         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.regexp.php
[\\\.]    [\\\(?:a)]    [\\\[a-z]]    [\\\{1}]    [\\\*]    [\\\+]    [\\\?]    [\\\^]    [\\\|]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^         ^             ^             ^           ^         ^         ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#   ^         ^^^^^         ^             ^ ^         ^         ^         ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#    ^    ^        ^    ^       ^     ^      ^    ^    ^    ^    ^    ^    ^    ^    ^    ^    ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#     ^^^^          ^^^^         ^^^^^        ^^^^      ^^^^      ^^^^      ^^^^      ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                            ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#                             ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#                                          ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.regexp.php
[\\\\.]   [\\\\(?:a)]   [\\\\[a-z]]   [\\\\{1}]   [\\\\*]   [\\\\+]   [\\\\?]   [\\\\^]   [\\\\|]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^        ^^            ^^            ^^          ^^        ^^        ^^        ^^        ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^         ^^^^^         ^             ^ ^         ^         ^         ^         ^         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#     ^   ^         ^   ^        ^    ^       ^   ^     ^   ^     ^   ^     ^   ^     ^   ^     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#      ^^^           ^^^          ^^^^         ^^^       ^^^       ^^^       ^^^       ^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                             ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#                              ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#                                           ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.regexp.php
[\\\\\.]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\(?:a)]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#          ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\[a-z]]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#       ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#         ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#          ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
[\\\\\{1}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.numeric.regexp.php
#       ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php
#        ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\*]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\+]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\?]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\^]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\\\\|]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php
#  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.escape.regexp.php
#    ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

# regression control
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php comment.line.number-sign.php punctuation.definition.comment.php
#^^^^^^^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php comment.line.number-sign.php
\d          \p{L}             \x{21}
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.regexp.php
#^          ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.regexp.php
# ^^^^^^^^^^     ^^^^^^^^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
#                             ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.numeric.regexp.php
[\d-\w]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#  ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\p{L}-\p{N}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^^^^ ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#           ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\x{21}\x{42}-\x{44}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#      ^^^^^^ ^^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php constant.character.numeric.regexp.php
#            ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#                   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php

\\d
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
#^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
# ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.regexp.php
\\p{L}
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
#^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.class.regexp.php
# ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.class.regexp.php
\\x{21}
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
#^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.escape.php constant.character.numeric.regexp.php
# ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php constant.character.numeric.regexp.php
[\\d-\\w]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^  ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.class.regexp.php
#  ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\p{L}-\\p{N}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^     ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.class.regexp.php
#  ^^^^   ^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.class.regexp.php
#      ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#             ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
[\\x{21}\x{42}-\\x{44}]
#<-source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.escape.php constant.character.numeric.regexp.php
#  ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php
#       ^^^^^^   ^^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php constant.character.numeric.regexp.php
#             ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#              ^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php constant.character.escape.php constant.character.numeric.regexp.php
#                     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
REGEX; 
#^^^^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php punctuation.section.embedded.end.php keyword.operator.heredoc.php
#    ^ source.php punctuation.terminator.expression.php
#     ^ source.php