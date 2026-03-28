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

foo(

#<-source.php meta.function-call.php
);
