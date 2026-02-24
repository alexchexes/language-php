<?php

/*------------------------------*
* SPECIFIC SCOPE FOR ARRAY KEYS *
*-------------------------------*/

$a = [
    "key"   => 'value',
    'key'   => 'value',
    2       => 'value',
];

function FunctionName($a) { 
    foreach ($a as $key => $value) {
        yield "key" => 'value';
        yield 'key' => 'value';
        yield 2     => 'value';
        yield 3     => 456;
        yield $key  => $value;
    }
}

fn() => null;
