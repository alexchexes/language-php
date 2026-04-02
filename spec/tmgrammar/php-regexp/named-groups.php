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

// Unicode named groups

// Extracted from: should accept Unicode letters and decimal digits in quoted named groups and conditionals
 "/(?<Ж١>a)/";
#     ^^ meta.embedded.group.regexp.php variable.other.regexp.php

// Extracted from: should accept Unicode letters and decimal digits in quoted named groups and conditionals
 "/(?P<Ж١>a)/";
#      ^^ meta.embedded.group.regexp.php variable.other.regexp.php

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?<Ж١>a)/
#    ^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?'Ж١'a)/
#    ^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?P<Ж١>a)/
#     ^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?<Ж١>a)/
#    ^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?'Ж١'a)/
#    ^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?P<Ж١>a)/
#     ^^ meta.embedded.group.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: accepts Unicode letters and decimal digits in apostrophe-delimited single quoted regex source forms
 '/(?\'Ж١\'a)/';
#      ^^ meta.embedded.group.regexp.php variable.other.regexp.php

// Invalid Unicode-start names

// Extracted from: should keep invalid Unicode-start quoted named groups and conditionals out of name scopes
 "/(?<١foo>a)/";
#     ^^^^ - variable.other.regexp.php

// Extracted from: should keep invalid Unicode-start quoted named groups and conditionals out of name scopes
 "/(?P<💩>a)/";
#      ^ - variable.other.regexp.php

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEX heredoc
<<<REGEX
 /(?<١foo>a)/
#    ^^^^ - variable.other.regexp.php
REGEX;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEX heredoc
<<<REGEX
 /(?'💩'a)/
#    ^ - variable.other.regexp.php
REGEX;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEXP nowdoc
<<<'REGEXP'
 /(?<١foo>a)/
#    ^^^^ - variable.other.regexp.php
REGEXP;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEXP nowdoc
<<<'REGEXP'
 /(?'💩'a)/
#    ^ - variable.other.regexp.php
REGEXP;

// Extracted from: keeps invalid Unicode-start apostrophe-delimited single quoted regex source forms out of name scopes
 '/(?\'١foo\'a)/';
#      ^^^^ - variable.other.regexp.php
