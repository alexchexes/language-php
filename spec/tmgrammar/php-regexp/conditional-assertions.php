# SYNTAX TEST "source.php" "regex conditional assertions"
<?php

// Classic assertion conditionals in quoted regexes

// Extracted from: should tokenize the supported assertion-conditional families in quoted regexes
 "/(?(?=aa)ab|ac)/";
#  ^            ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#     ^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#       ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#         ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#            ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported assertion-conditional families in quoted regexes
 '/(?(?<=ca)cb|cc)/';
#  ^             ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#     ^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.single-quoted.php
#        ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#          ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#             ^ keyword.operator.or.regexp.php

// Verb-style assertion conditionals in quoted regexes

// Extracted from: should tokenize the supported assertion-conditional families in quoted regexes
 "/(?(*pla:ea)eb|ec)/";
#  ^               ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#     ^^^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.double-quoted.php
#          ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#            ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#               ^ keyword.operator.or.regexp.php

// Extracted from: should tokenize the supported assertion-conditional families in quoted regexes
 '/(?(*positive_lookbehind:ja)jb|jc)/';
#  ^                               ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#    ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.single-quoted.php
#     ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                          ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#                            ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#                               ^ keyword.operator.or.regexp.php

// Assertion conditionals in explicit regex hosts

// Extracted from: should tokenize the supported assertion-conditional families in REGEX heredoc
<<<REGEX
 /(?(?=aa)ab|ac)/
# <------------------ string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^            ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#      ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#        ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#           ^ keyword.operator.or.regexp.php
REGEX;

// Extracted from: should tokenize the supported assertion-conditional families in REGEXP nowdoc
<<<'REGEXP'
 /(?(?<=ca)cb|cc)/
# <------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^             ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#    ^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.nowdoc.php
#       ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#         ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#            ^ keyword.operator.or.regexp.php
REGEXP;

// Extracted from: should tokenize the supported assertion-conditional families in REGEX heredoc
<<<REGEX
 /(?(*pla:ea)eb|ec)/
# <--------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^               ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.heredoc.php
#         ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#           ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#              ^ keyword.operator.or.regexp.php
REGEX;

// Extracted from: should tokenize the supported assertion-conditional families in REGEXP nowdoc
<<<'REGEXP'
 /(?(*positive_lookbehind:ja)jb|jc)/
# <------------------------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^                               ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.regexp.php
#  ^ meta.embedded.group.conditional.regexp.php keyword.control.conditional.begin.regexp.php
#   ^ meta.embedded.group.conditional.regexp.php punctuation.definition.group.conditional.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.conditional.regexp.php string.regexp.nowdoc.php
#                         ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#                           ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.conditional.regexp.php
#                              ^ keyword.operator.or.regexp.php
REGEXP;
