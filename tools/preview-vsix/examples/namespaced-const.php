<?php
namespace NS;

const foo = 111;

echo foo;  // 111
echo \foo;  // might be 222

echo \NS\foo;  // 111
echo NS\foo;  // fatal (assumes \NS\NS\foo)
?>
