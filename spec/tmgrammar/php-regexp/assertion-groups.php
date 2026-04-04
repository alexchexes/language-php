# SYNTAX TEST "source.php" "regex assertion groups"
<?php

// Classic lookaround assertion groups in quoted regexes

// Extracted from: should tokenize plain and lookaround assertion groups in quoted regexes
 "/(ab)(?=cd)(?!ef)(?<=gh)(?<!ij)/";
#  ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#      ^    ^^    ^^     ^^     ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#       ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#         ^^    ^^     ^^     ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#             ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                   ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                          ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php

// Extracted from: should tokenize plain and lookaround assertion groups in quoted regexes
 '/(ab)(?=cd)(?!ef)(?<=gh)(?<!ij)/';
#  ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#      ^    ^^    ^^     ^^     ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#       ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#         ^^    ^^     ^^     ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#             ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                   ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                          ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php

// Classic lookaround assertion groups in explicit regex hosts

// Extracted from: should tokenize assertion groups in REGEX heredoc
<<<REGEX
 /(?=ab)(?!cd)(?<=ef)(?<!gh)/
# <------------------------------ string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^    ^^    ^^     ^^     ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^    ^^     ^^     ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#        ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#              ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                     ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
REGEX;

// Extracted from: should tokenize assertion groups in REGEXP nowdoc
<<<'REGEXP'
 /(?=ab)(?!cd)(?<=ef)(?<!gh)/
# <------------------------------ string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^    ^^    ^^     ^^     ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^    ^^     ^^     ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#        ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#              ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                     ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
REGEXP;

// Verb-style assertion groups in quoted regexes

// Extracted from: should tokenize verb-style assertion groups in quoted regexes
 "/(*pla:ab)(*nla:cd)(*plb:ef)(*nlb:gh)/";
#  ^       ^^       ^^       ^^       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#        ^^       ^^       ^^       ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#            ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                     ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                              ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php

// Extracted from: should tokenize verb-style assertion groups in quoted regexes
 '/(*pla:ab)(*nla:cd)(*plb:ef)(*nlb:gh)/';
#  ^       ^^       ^^       ^^       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#        ^^       ^^       ^^       ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#            ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                     ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                              ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php

// Extracted from: should tokenize verb-style assertion groups in quoted regexes
 "/(*positive_lookahead:ab)(*negative_lookahead:cd)(*positive_lookbehind:ef)(*negative_lookbehind:gh)/";
#  ^                      ^^                      ^^                       ^^                       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                       ^^                      ^^                       ^^                       ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#                           ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                                                   ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                                                                            ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php

// Extracted from: should tokenize verb-style assertion groups in quoted regexes
 '/(*positive_lookahead:ab)(*negative_lookahead:cd)(*positive_lookbehind:ef)(*negative_lookbehind:gh)/';
#  ^                      ^^                      ^^                       ^^                       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                       ^^                      ^^                       ^^                       ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#                           ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                                                   ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                                                                            ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php

// Verb-style assertion groups in explicit regex hosts

// Extracted from: should tokenize verb-style assertion groups in REGEX heredoc
<<<REGEX
 /(*pla:ab)(*nla:cd)(*plb:ef)(*nlb:gh)/
# <--------------------------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^       ^^       ^^       ^^       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#       ^^       ^^       ^^       ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#           ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                    ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                             ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
REGEX;

// Extracted from: should tokenize verb-style assertion groups in REGEXP nowdoc
<<<'REGEXP'
 /(*pla:ab)(*nla:cd)(*plb:ef)(*nlb:gh)/
# <--------------------------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^       ^^       ^^       ^^       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#       ^^       ^^       ^^       ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#           ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                    ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                             ^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
REGEXP;

// Extracted from: should tokenize verb-style assertion groups in REGEX heredoc
<<<REGEX
 /(*positive_lookahead:ab)(*negative_lookahead:cd)(*positive_lookbehind:ef)(*negative_lookbehind:gh)/
# <----------------------------------------------------------------------------------------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^                      ^^                      ^^                       ^^                       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                      ^^                      ^^                       ^^                       ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#                          ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                                                  ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                                                                           ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
REGEX;

// Extracted from: should tokenize verb-style assertion groups in REGEXP nowdoc
<<<'REGEXP'
 /(*positive_lookahead:ab)(*negative_lookahead:cd)(*positive_lookbehind:ef)(*negative_lookbehind:gh)/
# <----------------------------------------------------------------------------------------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^                      ^^                      ^^                       ^^                       ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                      ^^                      ^^                       ^^                       ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#                          ^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-ahead.regexp.php
#                                                  ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
#                                                                           ^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
REGEXP;

// Non-atomic assertion groups in quoted regexes

// Extracted from: should tokenize non-atomic assertion groups in quoted regexes
 "/(?*ab)(?<*cd)(*napla:ef)(*naplb:gh)/";
#  ^    ^^     ^^         ^^         ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^           ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#     ^^     ^^         ^^         ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#         ^^^               ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php

// Extracted from: should tokenize non-atomic assertion groups in quoted regexes
 '/(?*ab)(?<*cd)(*napla:ef)(*naplb:gh)/';
#  ^    ^^     ^^         ^^         ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^           ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#     ^^     ^^         ^^         ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#         ^^^               ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php

// Extracted from: should tokenize non-atomic assertion groups in quoted regexes
 "/(*non_atomic_positive_lookahead:ab)(*non_atomic_positive_lookbehind:cd)/";
#  ^                                 ^^                                  ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                                  ^^                                  ^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php

// Extracted from: should tokenize non-atomic assertion groups in quoted regexes
 '/(*non_atomic_positive_lookahead:ab)(*non_atomic_positive_lookbehind:cd)/';
#  ^                                 ^^                                  ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                                  ^^                                  ^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php

// Non-atomic assertion groups in explicit regex hosts

// Extracted from: should tokenize non-atomic assertion groups in REGEX heredoc
<<<REGEX
 /(?*ab)(?<*cd)(*napla:ef)(*naplb:gh)/
# <-------------------------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^    ^^     ^^         ^^         ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^           ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^     ^^         ^^         ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#        ^^^               ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
REGEX;

// Extracted from: should tokenize non-atomic assertion groups in REGEXP nowdoc
<<<'REGEXP'
 /(?*ab)(?<*cd)(*napla:ef)(*naplb:gh)/
# <-------------------------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^    ^^     ^^         ^^         ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^           ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^     ^^         ^^         ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#        ^^^               ^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
REGEXP;

// Extracted from: should tokenize non-atomic assertion groups in REGEX heredoc
<<<REGEX
 /(*non_atomic_positive_lookahead:ab)(*non_atomic_positive_lookbehind:cd)/
# <-------------------------------------------------------------------------- string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^                                 ^^                                  ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                                 ^^                                  ^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
#                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
REGEX;

// Extracted from: should tokenize non-atomic assertion groups in REGEXP nowdoc
<<<'REGEXP'
 /(*non_atomic_positive_lookahead:ab)(*non_atomic_positive_lookbehind:cd)/
# <-------------------------------------------------------------------------- string.unquoted.nowdoc.php meta.embedded.regexp.php string.regexp.nowdoc.php
# ^                                 ^^                                  ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#                                 ^^                                  ^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
#                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-behind.regexp.php
REGEXP;
