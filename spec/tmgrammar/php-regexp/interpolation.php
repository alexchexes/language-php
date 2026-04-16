# SYNTAX TEST "source.php" "regex invalid escapes"
<?

// Extracted from: should tokenize interpolation inside double quoted regex bodies

 "/a*$b-c*$\n/";
#  ^^^^^^^^^^ source.php meta.embedded.regexp.php string.regexp.double-quoted.php
#   ^    ^ keyword.operator.quantifier.regexp.php
#    ^^ string.regexp.double-quoted.php variable.other.php
#    ^ variable.other.php punctuation.definition.variable.php
#      ^^^^^^ - variable.other.php
#         ^ keyword.control.anchor.regexp.php

 "/a*{$b}-c*$\n}/";
#  ^^^^^^^^^^^^^ source.php meta.embedded.regexp.php string.regexp.double-quoted.php
#   ^      ^ string.regexp.double-quoted.php keyword.operator.quantifier.regexp.php
#    ^  ^ string.regexp.double-quoted.php punctuation.definition.variable.php
#     ^^ string.regexp.double-quoted.php variable.other.php
#     ^ variable.other.php punctuation.definition.variable.php
#        ^^^^^^ - variable.other.php
#           ^ keyword.control.anchor.regexp.php

 "/a*{1}({$b('a*{1}')}c*$\n})/";
#   ^^^^               ^ keyword.operator.quantifier.regexp.php
#       ^                   ^ meta.embedded.group.regexp.php punctuation.definition.group.regexp.php
#        ^^^^^^^^^^^^^^^^^^^ meta.embedded.group.regexp.php string.regexp.double-quoted.php
#        ^^          ^ string.regexp.double-quoted.php punctuation.definition.variable.php
#          ^ variable.other.php
#            ^^^^^^^ meta.function-call.invoke.php string.quoted.single.php
#              ^^^^ - keyword.operator.quantifier.regexp.php punctuation.definition.variable.php
#                   ^ - punctuation.definition.group.regexp.php
#                     ^^^^^^^^ - variable.other.php punctuation.definition.variable.php meta.embedded.interpolation.php
#                       ^ keyword.control.anchor.regexp.php
// TODO: Uncomment this when https://github.com/KapitanOczywisty/language-php/pull/43 is merged:
// #        ^^^^^^^^^^^^^ meta.embedded.interpolation.php

// Range endpoints should hand off cleanly into interpolation.

 "/[a-$b]/";
#  ^^^^^^ source.php meta.embedded.regexp.php string.regexp.double-quoted.php meta.embedded.character-class.regexp.php
#  ^    ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#    ^ constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#     ^^ constant.other.character-class.set.regexp.php variable.other.php
#     ^ variable.other.php punctuation.definition.variable.php

 "/a([a-{$b(1-2, '[a-b]')}])/";
#    ^                    ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#     ^^^^^^^^^^^^^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#      ^ constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^                ^ constant.other.character-class.set.regexp.php punctuation.definition.variable.php
#        ^^ constant.other.character-class.set.regexp.php meta.function-call.invoke.php variable.other.php
#        ^ variable.other.php punctuation.definition.variable.php
#           ^ ^ meta.function-call.invoke.php constant.numeric.decimal.php
#            ^ meta.function-call.invoke.php keyword.operator.arithmetic.php
#                 ^^^^^ meta.function-call.invoke.php string.quoted.single.php

// actual example with whole interpolation expression replaced with an "atom" regex token:
 "/a([a-\x{42}])/";
#    ^^^^^^^^^^ source.php meta.embedded.regexp.php string.regexp.double-quoted.php meta.embedded.group.regexp.php string.regexp.double-quoted.php meta.embedded.character-class.regexp.php
#    ^        ^ meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#     ^^^^^^^^ string.regexp.character-class.php constant.other.character-class.set.regexp.php
#      ^ constant.other.character-class.set.regexp.php keyword.operator.range.regexp.php
#       ^^^^^^ constant.other.character-class.set.regexp.php constant.character.numeric.regexp.php

<<<REGEX

# Extracted from - should tokenize interpolation inside REGEXP heredoc groups

   a*$b-c*$\n
#      ^^^^^^ - variable.other.php
REGEX;

 '/a*$b-c*$\n/';
#  ^^^^^^^^^^ - variable.other.php

<<<'REGEX'
   a*$b-c*$\n
#  ^^^^^^^^^^ - variable.other.php
REGEX;
