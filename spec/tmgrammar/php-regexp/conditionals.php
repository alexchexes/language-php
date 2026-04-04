# SYNTAX TEST "source.php" "regex conditionals"
<?php

// Supported non-assertion conditionals in quoted regexes

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 "/(?(1)ab|cd)/";
#  ^         ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^ ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^ meta.embedded.group.conditional.regexp.php constant.numeric.regexp.php
#       ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#         ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 '/(?(<word>)ef|gh)/';
#  ^  ^    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^ punctuation.definition.group.capture.begin.regexp.php
#      ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#          ^ punctuation.definition.group.capture.end.regexp.php
#            ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.single-quoted.php
#              ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 "/(?('word')ij|kl)/";
#  ^  ^    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^ punctuation.definition.group.capture.begin.regexp.php
#      ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#          ^ punctuation.definition.group.capture.end.regexp.php
#            ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#              ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 '/(?(word)mn|op)/';
#  ^            ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#          ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.single-quoted.php
#            ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 "/(?(R)qr|st)/";
#  ^         ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^ ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^ meta.embedded.group.conditional.regexp.php keyword.other.recursion.regexp.php
#       ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#         ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 '/(?(R1)uv|wx)/';
#  ^          ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^  ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^ meta.embedded.group.conditional.regexp.php keyword.other.recursion.regexp.php
#      ^ meta.embedded.group.conditional.regexp.php constant.numeric.regexp.php
#        ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.single-quoted.php
#          ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 "/(?(R&word)yz|za)/";
#  ^              ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^ meta.embedded.group.conditional.regexp.php keyword.other.recursion.regexp.php
#       ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#            ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#              ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 '/(?(DEFINE)(?<word>ab))/';
#  ^                    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^^^^^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.regexp.php
#            ^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.single-quoted.php meta.embedded.group.regexp.php
#            ^^^    ^  ^ punctuation.definition.group.regexp.php
#             ^^ punctuation.definition.group.capture.begin.regexp.php
#               ^^^^ variable.other.regexp.php
#                   ^ punctuation.definition.group.capture.end.regexp.php

// Extracted from: should tokenize the supported non-assertion conditional families in quoted regexes
 "/(?(VERSION>=10.4)bc|de)/";
#  ^                     ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^             ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.regexp.php
#                   ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#                     ^ keyword.operator.or.regexp.php

// Supported non-assertion conditionals in explicit regex hosts

// Extracted from: should tokenize the supported non-assertion conditional families in REGEX heredoc
<<<REGEX
 /(?(1)ab|cd)/
# <--------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^         ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^ ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php constant.numeric.regexp.php
#      ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#        ^ keyword.operator.or.regexp.php
REGEX;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEXP nowdoc
<<<'REGEXP'
 /(?(<word>)ef|gh)/
# <-------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^  ^    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#         ^ punctuation.definition.group.capture.end.regexp.php
#           ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.nowdoc.php
#             ^ keyword.operator.or.regexp.php
REGEXP;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEX heredoc
<<<REGEX
 /(?('word')ij|kl)/
# <-------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^  ^    ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^ punctuation.definition.group.capture.begin.regexp.php
#     ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#         ^ punctuation.definition.group.capture.end.regexp.php
#           ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#             ^ keyword.operator.or.regexp.php
REGEX;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEXP nowdoc
<<<'REGEXP'
 /(?(word)mn|op)/
# <------------------ string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^            ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#         ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.nowdoc.php
#           ^ keyword.operator.or.regexp.php
REGEXP;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEX heredoc
<<<REGEX
 /(?(R)qr|st)/
# <--------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^         ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^ ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php keyword.other.recursion.regexp.php
#      ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#        ^ keyword.operator.or.regexp.php
REGEX;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEXP nowdoc
<<<'REGEXP'
 /(?(R1)uv|wx)/
# <---------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^          ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^  ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php keyword.other.recursion.regexp.php
#     ^ meta.embedded.group.conditional.regexp.php constant.numeric.regexp.php
#       ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.nowdoc.php
#         ^ keyword.operator.or.regexp.php
REGEXP;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEX heredoc
<<<REGEX
 /(?(R&word)yz|za)/
# <-------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^              ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^ meta.embedded.group.conditional.regexp.php keyword.other.recursion.regexp.php
#      ^^^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
#           ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#             ^ keyword.operator.or.regexp.php
REGEX;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEXP nowdoc
<<<'REGEXP'
 /(?(DEFINE)(?<word>ab))/
# <-------------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^                    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^      ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^^^^^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.regexp.php
#           ^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.nowdoc.php meta.embedded.group.regexp.php
#           ^^^    ^  ^ punctuation.definition.group.regexp.php
#            ^^ punctuation.definition.group.capture.begin.regexp.php
#              ^^^^ variable.other.regexp.php
#                  ^ punctuation.definition.group.capture.end.regexp.php
#                   ^^ string.regexp.nowdoc.php
REGEXP;

// Extracted from: should tokenize the supported non-assertion conditional families in REGEX heredoc
<<<REGEX
 /(?(VERSION>=10.4)bc|de)/
# <--------------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^                     ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^             ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.regexp.php
#                  ^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#                    ^ keyword.operator.or.regexp.php
REGEX;

// Unicode named conditionals in quoted regexes

// Extracted from: should accept Unicode letters and decimal digits in quoted named groups and conditionals
 "/(?(<Ж١>)a|b)/";
#      ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php

// Extracted from: should accept Unicode letters and decimal digits in quoted named groups and conditionals
 "/(?(R&Ж١)a|b)/";
#       ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php

// Extracted from: should accept Unicode letters and decimal digits in quoted named groups and conditionals
 "/(?(Ж١)a|b)/";
#     ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php

// Extracted from: should keep invalid Unicode-start quoted named groups and conditionals out of name scopes
 "/(?(١foo)a|b)/";
#     ^^^^ - variable.other.regexp.php

// Extracted from: should keep invalid Unicode-start quoted named groups and conditionals out of name scopes
 "/(?(<💩>)a|b)/";
#      ^ - variable.other.regexp.php

// Extracted from: should keep invalid Unicode-start quoted named groups and conditionals out of name scopes
 "/(?(R&١foo)a|b)/";
#       ^^^^ - variable.other.regexp.php

// Unicode named conditionals in apostrophe-delimited single-quoted regex source forms

// Extracted from: accepts Unicode letters and decimal digits in apostrophe-delimited single quoted regex source forms
 '/(?(\'Ж١\')a|b)/';
#       ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php

// Extracted from: keeps invalid Unicode-start apostrophe-delimited single quoted regex source forms out of name scopes
 '/(?(\'١foo\')a|b)/';
#       ^^^^ - variable.other.regexp.php

// Unicode named conditionals in explicit regex hosts

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?(<Ж١>)a|b)/
#     ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?('Ж١')a|b)/
#     ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?(R&Ж١)a|b)/
#      ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?(Ж١)a|b)/
#    ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEXP;

// Invalid Unicode-start names in explicit conditionals

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEX heredoc
<<<REGEX
 /(?(١foo)a|b)/
#    ^^^^ - variable.other.regexp.php
REGEX;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEXP nowdoc
<<<'REGEXP'
 /(?(<💩>)a|b)/
#     ^ - variable.other.regexp.php
REGEXP;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEX heredoc
<<<REGEX
 /(?(R&١foo)a|b)/
#      ^^^^ - variable.other.regexp.php
REGEX;
