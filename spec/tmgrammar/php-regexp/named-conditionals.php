# SYNTAX TEST "source.php" "regex named conditionals"
<?php

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

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?('Ж١')a|b)/
#     ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?(R&Ж١)a|b)/
#      ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEX heredoc
<<<REGEX
 /(?(Ж١)a|b)/
#    ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?(<Ж١>)a|b)/
#     ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?('Ж١')a|b)/
#     ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEXP;

// Extracted from: should accept Unicode letters and decimal digits in named groups and conditionals in REGEXP nowdoc
<<<'REGEXP'
 /(?(R&Ж١)a|b)/
#      ^^ meta.embedded.group.conditional.regexp.php variable.other.regexp.php
REGEXP;

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

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEX heredoc
<<<REGEX
 /(?(<💩>)a|b)/
#     ^ - variable.other.regexp.php
REGEX;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEX heredoc
<<<REGEX
 /(?(R&١foo)a|b)/
#      ^^^^ - variable.other.regexp.php
REGEX;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEXP nowdoc
<<<'REGEXP'
 /(?(١foo)a|b)/
#    ^^^^ - variable.other.regexp.php
REGEXP;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEXP nowdoc
<<<'REGEXP'
 /(?(<💩>)a|b)/
#     ^ - variable.other.regexp.php
REGEXP;

// Extracted from: should keep invalid Unicode-start named groups and conditionals out of name scopes in REGEXP nowdoc
<<<'REGEXP'
 /(?(R&١foo)a|b)/
#      ^^^^ - variable.other.regexp.php
REGEXP;
