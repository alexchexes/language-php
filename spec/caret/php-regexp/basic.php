<?php

// target zero-width token on an empty line with `<-`

#<-text.html.php meta.embedded.block.php source.php

// target non-zero-width token with `<-`
1;
#<-source.php constant.numeric.decimal.php
#^ source.php punctuation.terminator.expression.php

// white-space 1
 
#<-source.php

// white-space 2
  
#^ source.php

// white-space 3
   
#^^ source.php

// leading white-space targeting 1
   foo();
#^^ source.php
#  ^^^ source.php meta.function-call.php entity.name.function.php
#     ^ source.php meta.function-call.php punctuation.definition.arguments.begin.bracket.round.php
#      ^ source.php meta.function-call.php punctuation.definition.arguments.end.bracket.round.php
#       ^ source.php punctuation.terminator.expression.php

// leading white-space targeting 2
   foo();
#<-source.php
#^^ source.php
#  ^^^ source.php meta.function-call.php entity.name.function.php
#     ^ source.php meta.function-call.php punctuation.definition.arguments.begin.bracket.round.php
#      ^ source.php meta.function-call.php punctuation.definition.arguments.end.bracket.round.php
#       ^ source.php punctuation.terminator.expression.php

 '/[a-z]/';
#^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php punctuation.definition.string.begin.php
# ^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php punctuation.definition.string.begin.regexp.php
#  ^   ^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php meta.embedded.character-class.regexp.php punctuation.definition.character-class.regexp.php
#   ^ ^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php variable.other.constant.range.regexp.php
#    ^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php meta.embedded.character-class.regexp.php string.regexp.character-class.php constant.other.character-class.set.regexp.php constant.other.character-class.range.regexp.php keyword.operator.range.regexp.php
#       ^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php punctuation.definition.string.end.regexp.php
#        ^ source.php meta.embedded.regexp.php string.regexp.single-quoted.php punctuation.definition.string.end.php
#         ^ source.php punctuation.terminator.expression.php


" foo";
#^^^^ source.php string.quoted.double.php
#    ^ source.php string.quoted.double.php punctuation.definition.string.end.php
#     ^ source.php punctuation.terminator.expression.php

"    foo; ;";
#^^^^^^^^^^ source.php string.quoted.double.php
#          ^ source.php string.quoted.double.php punctuation.definition.string.end.php
#           ^ source.php punctuation.terminator.expression.php

    foo; ;
#   ^^^ source.php constant.other.php
#      ^ ^ source.php punctuation.terminator.expression.php
#       ^ source.php
