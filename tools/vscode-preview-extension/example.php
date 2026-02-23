<?php

namespace Some\Foo;

class Bar {}

/**
 * @access private
 * 
 * @param int $foo
 * @param int $foo descr
 * 
 * @param positive-int $foo
 * @param positive-int $foo descr
 * 
 * @param int|'b' $foo
 * @param int|'b' $foo descr
 * @param 'a'|'b' $foo
 * @param 'a'|'b' $foo descr
 * @param 'a'|123 $foo
 * @param 'a'|123 $foo descr
 * @param 123|'a' $foo
 * @param 123|'a' $foo descr
 * @param 123|345 $foo
 * @param 123|345 $foo descr
 * 
 * @param 'a'|Foo\Bar|int[] &$bar
 * @param 'a'|Foo\Bar|int[] &$bar descr
 * 
 * @param int[]|'blog' $foo
 * @param int[]|'blog' $foo descr
 * 
 * @param \Some\Foo\Bar $bar
 * @param \Some\Foo\Bar $bar descr
 * 
 * @param \Some\Foo\Bar &$bar
 * @param \Some\Foo\Bar &$bar descr
 * 
 * @var int[] $foo
 * @var int[] $foo descr
 * 
 * @property int $foo
 * @property int $foo descr
 * 
 * @throws \Some\Foo\FooException $foo
 * @throws \Some\Foo\FooException $foo descr
 * @return ?int $foo
 * @return ?int $foo descr
 * 
 * @someTag int $foo descr
 */
function foo(?int $foo = 123, \Some\Foo\Bar &$bar, ?string $baz = 'xyz'): int
{
    print_r($foo);

    \print_r($bar);

    /** @var class-string<\Some\Foo\Bar> */
    \Some\Foo\Bar::class;

    return 123;
}

$a = static fn() => null;

/** @param 123|345 $foo descr */
/** @var int $a */
/** @var $a */

/** 
 * @param int $a1
 * @param int &$a2
 * @param $a5
 * @param &$a6
 * @param int ...$a3
 * @param int ...$a9 description
 * @param int &...$a4
 * @param ...$a7
 * @param &...$a8
 * @param int description
 */
function foo1(
    int $a1,
    int &$a2,
    $a5,
    &$a6,
    int &...$a4,
): void
{
    func_get_args();
}
function foo2(int ...$a3) {}
function foo3(...$a7) {}
function foo4(&...$a8) {}

/*----------------------*
*         Short         *
*-----------------------*/
 
namespace App\Service;

/**
 * @property string $status
 */
abstract class ExampleClass
{
    protected string $status;

    /**
     * @param int $limit
     * @param ?array &$ids Description
     * @param Status $status description
     * @param 'json'|123 $format (literal unions aren't really handled)
     * @param list<int> &...$list Variadic + by-reference
     *
     * @throws \RuntimeException $notTokenized as expected
     * @return array $notTokenized as expected
     */

    abstract public function exmpl(int $limit, ?array &$ids, int $status, string $format, ?array &...$list): array;
}
