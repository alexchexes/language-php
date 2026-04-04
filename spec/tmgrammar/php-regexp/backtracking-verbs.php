# SYNTAX TEST "source.php" "regex backtracking verbs"
<?php

// Standard backtracking verbs in quoted regexes

// Extracted from: should tokenize backtracking verbs in quoted regexes
 "/(*ACCEPT)(*FAIL)(*F)(*COMMIT)(*PRUNE)(*SKIP)(*THEN)/";
#  ^       ^^     ^^  ^^       ^^      ^^     ^^     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.accept.regexp.php
#            ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.fail.regexp.php
#                   ^^ meta.embedded.group.regexp.php keyword.control.backtracking.f.regexp.php
#                       ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.prune.regexp.php
#                                        ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                               ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php

// Extracted from: should tokenize backtracking verbs in quoted regexes
 '/(*ACCEPT)(*FAIL)(*F)(*COMMIT)(*PRUNE)(*SKIP)(*THEN)/';
#  ^       ^^     ^^  ^^       ^^      ^^     ^^     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.accept.regexp.php
#            ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.fail.regexp.php
#                   ^^ meta.embedded.group.regexp.php keyword.control.backtracking.f.regexp.php
#                       ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.prune.regexp.php
#                                        ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                               ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php

// Extracted from: should tokenize backtracking verbs in quoted regexes
 "/(*MARK:label)(*SKIP:label)/";
#  ^           ^^           ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#         ^^^^^        ^^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#                ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php

// Extracted from: should tokenize backtracking verbs in quoted regexes
 '/(*MARK:label)(*SKIP:label)/';
#  ^           ^^           ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#         ^^^^^        ^^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#                ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php

// Standard backtracking verbs in explicit regex hosts

// Extracted from: should tokenize backtracking verbs in REGEX heredoc
<<<REGEX
 /(*ACCEPT)(*FAIL)(*F)(*COMMIT)(*PRUNE)(*SKIP)(*THEN)/
# ^       ^^     ^^  ^^       ^^      ^^     ^^     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.accept.regexp.php
#           ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.fail.regexp.php
#                  ^^ meta.embedded.group.regexp.php keyword.control.backtracking.f.regexp.php
#                      ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                               ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.prune.regexp.php
#                                       ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                              ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php
REGEX;

// Extracted from: should tokenize backtracking verbs in REGEXP nowdoc
<<<'REGEXP'
 /(*ACCEPT)(*FAIL)(*F)(*COMMIT)(*PRUNE)(*SKIP)(*THEN)/
# ^       ^^     ^^  ^^       ^^      ^^     ^^     ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.accept.regexp.php
#           ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.fail.regexp.php
#                  ^^ meta.embedded.group.regexp.php keyword.control.backtracking.f.regexp.php
#                      ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                               ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.prune.regexp.php
#                                       ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                              ^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php
REGEXP;

// Extracted from: should tokenize backtracking verbs in REGEX heredoc
<<<REGEX
 /(*:label)(*ACCEPT:label)(*FAIL:label)(*F:label)(*MARK:label)(*COMMIT:label)(*PRUNE:label)(*SKIP:label)(*THEN:label)/
# ^       ^^             ^^           ^^        ^^           ^^             ^^            ^^           ^^           ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#    ^^^^^          ^^^^^        ^^^^^     ^^^^^        ^^^^^          ^^^^^         ^^^^^        ^^^^^        ^^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#           ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.accept.regexp.php
#                          ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.fail.regexp.php
#                                       ^^^ meta.embedded.group.regexp.php keyword.control.backtracking.f.regexp.php
#                                                              ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                                                             ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.prune.regexp.php
#                                                                                           ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                                                                                        ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php
REGEX;

// Extracted from: should tokenize backtracking verbs in REGEXP nowdoc
<<<'REGEXP'
 /(*:label)(*ACCEPT:label)(*FAIL:label)(*F:label)(*MARK:label)(*COMMIT:label)(*PRUNE:label)(*SKIP:label)(*THEN:label)/
# ^       ^^             ^^           ^^        ^^           ^^             ^^            ^^           ^^           ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#    ^^^^^          ^^^^^        ^^^^^     ^^^^^        ^^^^^          ^^^^^         ^^^^^        ^^^^^        ^^^^^ meta.embedded.group.regexp.php variable.other.regexp.php
#           ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.accept.regexp.php
#                          ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.fail.regexp.php
#                                       ^^^ meta.embedded.group.regexp.php keyword.control.backtracking.f.regexp.php
#                                                              ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                                                             ^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.prune.regexp.php
#                                                                                           ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                                                                                        ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php
REGEXP;

// Default-PCRE2 punctuation-heavy labels

// Extracted from: should allow default-PCRE2 punctuation-heavy backtracking verb labels in quoted regexes
 "/(*:foo-bar)(*MARK:two words)(*COMMIT:1)(*SKIP:!done)(*THEN:💩)/";
#  ^         ^^               ^^         ^^           ^^        ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#     ^^^^^^^        ^^^^^^^^^          ^        ^^^^^        ^^ meta.embedded.group.regexp.php variable.other.regexp.php
#                               ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                          ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                                       ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php

// Extracted from: should allow default-PCRE2 punctuation-heavy verb labels in REGEX heredoc
<<<REGEX
 /(*:foo-bar)(*MARK:two words)(*COMMIT:1)(*SKIP:!done)(*THEN:💩)/
# ^         ^^               ^^         ^^           ^^        ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#    ^^^^^^^        ^^^^^^^^^          ^        ^^^^^        ^^ meta.embedded.group.regexp.php variable.other.regexp.php
#                              ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                         ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                                      ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php
REGEX;

// Extracted from: should allow default-PCRE2 punctuation-heavy verb labels in REGEXP nowdoc
<<<'REGEXP'
 /(*:foo-bar)(*MARK:two words)(*COMMIT:1)(*SKIP:!done)(*THEN:💩)/
# ^         ^^               ^^         ^^           ^^        ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^ meta.embedded.group.regexp.php keyword.control.backtracking.mark.regexp.php
#    ^^^^^^^        ^^^^^^^^^          ^        ^^^^^        ^^ meta.embedded.group.regexp.php variable.other.regexp.php
#                              ^^^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.commit.regexp.php
#                                         ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.skip.regexp.php
#                                                      ^^^^^^ meta.embedded.group.regexp.php keyword.control.backtracking.then.regexp.php
REGEXP;

// Incomplete or empty named backtracking verbs should stay plain

// Extracted from: should keep incomplete or empty named backtracking verbs plain in quoted regexes
 "/(*MARK:)(*SKIP:two words/";
#  ^      ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^  ^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#   ^^^^^^  ^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.control.backtracking.skip.regexp.php variable.other.regexp.php

// Extracted from: should keep incomplete or empty named backtracking verbs plain in quoted regexes
 '/(*MARK:)(*SKIP:two words/';
#  ^      ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#   ^^^^^^  ^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php string.regexp.single-quoted.php
#   ^^^^^^  ^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.control.backtracking.skip.regexp.php variable.other.regexp.php

// Extracted from: should keep incomplete or empty named backtracking verbs plain in REGEX heredoc
<<<REGEX
 /(*MARK:)(*SKIP:two words/
# ^      ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^  ^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php string.regexp.heredoc.php
#  ^^^^^^  ^^^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.control.backtracking.skip.regexp.php variable.other.regexp.php
REGEX;

// Extracted from: should keep incomplete or empty named backtracking verbs plain in REGEXP nowdoc
<<<'REGEXP'
 /(*MARK:)(*SKIP:two words/
# ^      ^^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#  ^^^^^^  ^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php string.regexp.nowdoc.php
#  ^^^^^^  ^^^^^^^^^^^^^^^^^ - keyword.control.backtracking.mark.regexp.php keyword.control.backtracking.skip.regexp.php variable.other.regexp.php
REGEXP;
