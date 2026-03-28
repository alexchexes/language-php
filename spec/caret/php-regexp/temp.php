<?php

 '/[a-z]/';
#^^^^^^^^^ meta.embedded.regexp.php string.regexp.single-quoted.php
#^ string.regexp.single-quoted.php punctuation.definition.string.begin.php
# ^ string.regexp.single-quoted.php punctuation.definition.string.begin.regexp.php
#  ^   ^ string.regexp.single-quoted.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^^^ string.regexp.single-quoted.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php
#   ^ ^ constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#    ^ constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#       ^ string.regexp.single-quoted.php punctuation.definition.string.end.regexp.php
#        ^ string.regexp.single-quoted.php punctuation.definition.string.end.php
#         ^ punctuation.terminator.expression.php

<<<REGEX
 /[a-z]/
#^     ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php
# ^   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#  ^ ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#   ^ source.php string.unquoted.heredoc.php meta.embedded.regexp.php string.regexp.heredoc.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
REGEX;