# SYNTAX TEST "source.php" "regex group boundaries"
<?php

// Quoted wrapper-boundary behavior

// Extracted from: should stop unclosed plain groups at the quoted wrapper boundary
 "/a(foo/";
#   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#       ^ punctuation.definition.string.end.regexp.php
#        ^ punctuation.definition.string.end.php
#         ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed plain groups at the quoted wrapper boundary
 '/a(foo/';
#   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#       ^ punctuation.definition.string.end.regexp.php
#        ^ punctuation.definition.string.end.php
#         ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed assertion groups at the quoted wrapper boundary
 "/a(?=foo/";
#   ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#    ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#      ^^^ meta.embedded.group.assertion.regexp.php string.regexp.double-quoted.php
#         ^ punctuation.definition.string.end.regexp.php
#          ^ punctuation.definition.string.end.php
#           ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed assertion groups at the quoted wrapper boundary
 '/a(?<!foo/';
#   ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#    ^^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.negative-look-behind.regexp.php
#       ^^^ meta.embedded.group.assertion.regexp.php string.regexp.single-quoted.php
#          ^ punctuation.definition.string.end.regexp.php
#           ^ punctuation.definition.string.end.php
#            ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed non-capturing and option groups at the quoted wrapper boundary
 "/a(?:foo/";
#   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
#      ^^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#         ^ punctuation.definition.string.end.regexp.php
#          ^ punctuation.definition.string.end.php
#           ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed non-capturing and option groups at the quoted wrapper boundary
 '/a(?:foo/';
#   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
#      ^^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#         ^ punctuation.definition.string.end.regexp.php
#          ^ punctuation.definition.string.end.php
#           ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed non-capturing and option groups at the quoted wrapper boundary
 "/a(?im:foo/";
#   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.option.regexp.php
#     ^^ meta.embedded.group.regexp.php storage.modifier.regexp.php
#        ^^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#           ^ punctuation.definition.string.end.regexp.php
#            ^ punctuation.definition.string.end.php
#             ^ punctuation.terminator.expression.php

// Extracted from: should stop unclosed non-capturing and option groups at the quoted wrapper boundary
 '/a(?im:foo/';
#   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#    ^  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.option.regexp.php
#     ^^ meta.embedded.group.regexp.php storage.modifier.regexp.php
#        ^^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#           ^ punctuation.definition.string.end.regexp.php
#            ^ punctuation.definition.string.end.php
#             ^ punctuation.terminator.expression.php

// Explicit multiline and terminator boundaries

// Extracted from: should keep multiline groups open in REGEX heredoc
<<<REGEX
 /(ab
# ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
 cd)/
#  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
REGEX;

// Extracted from: should keep multiline groups open in REGEXP nowdoc
<<<'REGEXP'
 /(ab
# ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
 cd)/
#  ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
REGEXP;

// Extracted from: should stop multiline unclosed groups at the terminator in REGEX heredoc
<<<REGEX
 /(ab
# ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;
# <----- punctuation.section.embedded.end.php keyword.operator.heredoc.php
#    ^ punctuation.terminator.expression.php

// Extracted from: should stop multiline unclosed groups at the terminator in REGEXP nowdoc
<<<'REGEXP'
 /(ab
# ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;
# <------ punctuation.section.embedded.end.php keyword.operator.nowdoc.php
#     ^ punctuation.terminator.expression.php

// Extracted from: should stop multiline unclosed assertion groups at the terminator in REGEX heredoc
<<<REGEX
 /(?=ab
# ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^^ meta.embedded.group.assertion.regexp.php string.regexp.heredoc.php
REGEX;
# <----- punctuation.section.embedded.end.php keyword.operator.heredoc.php
#    ^ punctuation.terminator.expression.php

// Extracted from: should stop multiline unclosed assertion groups at the terminator in REGEXP nowdoc
<<<'REGEXP'
 /(?=ab
# ^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.assertion.regexp.php punctuation.definition.group.assertion.regexp.php meta.assertion.look-ahead.regexp.php
#    ^^^ meta.embedded.group.assertion.regexp.php string.regexp.nowdoc.php
REGEXP;
# <------ punctuation.section.embedded.end.php keyword.operator.nowdoc.php
#     ^ punctuation.terminator.expression.php

// Non-capturing groups in explicit regex hosts

// Extracted from: should tokenize non-capturing groups in REGEX heredoc
<<<REGEX
 /(?:ab)/
# ^    ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
#    ^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
REGEX;

// Extracted from: should tokenize non-capturing groups in REGEXP nowdoc
<<<'REGEXP'
 /(?:ab)/
# ^    ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php punctuation.definition.group.no-capture.regexp.php
#    ^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
REGEXP;
