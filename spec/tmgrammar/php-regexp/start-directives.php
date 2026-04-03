# SYNTAX TEST "source.php" "regex start directives"
<?php

// Limit directives

// Extracted from: should tokenize start directives in quoted regexes
 "/(*LIMIT_MATCH=10)(*UTF)(*UCP)/";
#  ^               ^^    ^^    ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^  ^^^^  ^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php

// Extracted from: should tokenize start directives in quoted regexes
 '/(*LIMIT_MATCH=10)(*UTF)(*UCP)/';
#  ^               ^^    ^^    ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^^^  ^^^^  ^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php

// Extracted from: should tokenize start directives in REGEX heredoc
<<<REGEX
 /(*LIMIT_DEPTH=10)(*LIMIT_HEAP=11)(*LIMIT_MATCH=12)/
# ^               ^^              ^^               ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php
REGEX;

// Extracted from: should tokenize start directives in REGEXP nowdoc
<<<'REGEXP'
 /(*LIMIT_DEPTH=10)(*LIMIT_HEAP=11)(*LIMIT_MATCH=12)/
# ^               ^^              ^^               ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php
REGEXP;

// Matching and optimization directives

// Extracted from: should tokenize start directives in quoted regexes
 "/(*NO_START_OPT)(*CRLF)(*BSR_UNICODE)/";
#  ^             ^^     ^^            ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^  ^^^^^  ^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php

// Extracted from: should tokenize start directives in quoted regexes
 '/(*NO_START_OPT)(*CRLF)(*BSR_UNICODE)/';
#  ^             ^^     ^^            ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^^^^^^^  ^^^^^  ^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php

// Extracted from: should tokenize start directives in REGEX heredoc
<<<REGEX
 /(*CASELESS_RESTRICT)(*NOTEMPTY_ATSTART)(*NOTEMPTY)(*NO_AUTO_POSSESS)/
# ^                  ^^                 ^^         ^^                ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^  ^^^^^^^^^  ^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php

 /(*NO_DOTSTAR_ANCHOR)(*NO_START_OPT)(*NO_JIT)(*TURKISH_CASING)/
# ^                  ^^             ^^       ^^               ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^  ^^^^^^^  ^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php
REGEX;

// Extracted from: should tokenize start directives in REGEXP nowdoc
<<<'REGEXP'
 /(*CASELESS_RESTRICT)(*NOTEMPTY_ATSTART)(*NOTEMPTY)(*NO_AUTO_POSSESS)/
# ^                  ^^                 ^^         ^^                ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^  ^^^^^^^^^  ^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php

 /(*NO_DOTSTAR_ANCHOR)(*NO_START_OPT)(*NO_JIT)(*TURKISH_CASING)/
# ^                  ^^             ^^       ^^               ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^  ^^^^^^^  ^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php
REGEXP;

// Newline and line-ending directives

// Extracted from: should tokenize start directives in REGEX heredoc
<<<REGEX
 /(*BSR_ANYCRLF)(*BSR_UNICODE)(*ANYCRLF)(*ANY)(*NUL)(*CR)(*LF)/
# ^            ^^            ^^        ^^    ^^    ^^   ^^   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^  ^^^^^^^^^^^^  ^^^^^^^^  ^^^^  ^^^^  ^^^  ^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php
REGEX;

// Extracted from: should tokenize start directives in REGEXP nowdoc
<<<'REGEXP'
 /(*BSR_ANYCRLF)(*BSR_UNICODE)(*ANYCRLF)(*ANY)(*NUL)(*CR)(*LF)/
# ^            ^^            ^^        ^^    ^^    ^^   ^^   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^^^^^^  ^^^^^^^^^^^^  ^^^^^^^^  ^^^^  ^^^^  ^^^  ^^^ meta.embedded.group.regexp.php keyword.control.directive.regexp.php
REGEXP;
