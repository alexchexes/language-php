<?php

$var = 'xyz';

/*--------------------------*
*         LITERAL          *
*---------------------------*/
 
$a = <<<'SQL'
    foo LIKE '%{$var}%'
    AND baz ILIKE '%{$var}%'
SQL;

$a = <<<'REGEXP'
    ^[^a-z0-9]{2,4}\s+{$var}$
REGEXP;

$a = <<<'JSON'
    {
        "key1": "{$var}",
        "key2": "{\$var}",
        "key3": ["el1", "el2"]
    }
JSON;

$a = <<<'YAML'
    key1: {$var}
    key2:
    - el1
    - el2
YAML;

$a = <<<'PHP'
    $year = foo('{$var}');
PHP;

$a = <<<'MARKDOWN'
    # Header
    ## {$var}
    `code`
    ```ts
    type A = 'FOO'|'BAR';
    ```
    ### Header
MARKDOWN;

/*----------------------------*
*        INTERPOLATION        *
*-----------------------------*/

$a = <<<SQL
    foo LIKE '%{$var}%'
    AND baz ILIKE '%qux%'
SQL;

$a = <<<REGEXP
    ^[^a-z0-9]{2,4}\s+{$var}$
REGEXP;

$a = <<<JSON
    {
        "key1": "{$var}",
        "key2": "{\$var}",
        "key3": ["el1", "el2"]
    }
JSON;

$a = <<<YAML
    key1: {$var}
    key2:
    - el1
    - el2
YAML;

$a = <<<PHP
    $year = foo('{$var}');
PHP;
