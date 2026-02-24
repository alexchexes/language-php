<?php

/*----------------------*
*         Short         *
*-----------------------*/
 
namespace App\Service;

/**
 * @property string $fooBar
 */
abstract class ExampleClass
{
    protected string $fooBar;

    /**
     * @param $fooBar1
     * @param int $fooBar1
     * @param Status $fooBar3 description
     * @param 'json'|123 $fooBar4 (literal unions aren't really handled)
     * @param  ...$fooBar5 Variadic
     * @param list<int> &$fooBar2 by reference
     * @param ?array &...$fooBar5 Variadic + by-reference
     *
     * @throws \RuntimeException $notTokenized as expected
     * @return array $notTokenized as expected
     */
    abstract public function exmpl(int $fooBar1, ?array &$fooBar2, int $fooBar3, string $fooBar4, ?array &...$fooBar5): array;
}

/*-----------------------*
*          FULL          *
*------------------------*/

namespace Some\Foo;

class Bar {}

/**
 * @access private
 * 
 * @param int $fooBar
 * @param int $fooBar descr
 * 
 * @param positive-int $fooBar
 * @param positive-int $fooBar descr
 * 
 * @param int|'b' $fooBar
 * @param int|'b' $fooBar descr
 * @param 'a'|'b' $fooBar
 * @param 'a'|'b' $fooBar descr
 * @param 'a'|123 $fooBar
 * @param 'a'|123 $fooBar descr
 * @param 123|'a' $fooBar
 * @param 123|'a' $fooBar descr
 * @param 123|345 $fooBar
 * @param 123|345 $fooBar descr
 * 
 * @param 'a'|Foo\Bar|int[] &$fooBar2
 * @param 'a'|Foo\Bar|int[] &$fooBar2 descr
 * 
 * @param int[]|'blog' $fooBar
 * @param int[]|'blog' $fooBar descr
 * 
 * @param \Some\Foo\Bar $fooBar2
 * @param \Some\Foo\Bar $fooBar2 descr
 * 
 * @param \Some\Foo\Bar &$fooBar2
 * @param \Some\Foo\Bar &$fooBar2 descr
 * 
 * @var int[] $fooBar
 * @var int[] $fooBar descr
 * 
 * @property int $fooBar
 * @property int $fooBar descr
 * 
 * @throws \Some\Foo\FooException $foo
 * @throws \Some\Foo\FooException $foo descr
 * @return ?int $foo
 * @return ?int $foo descr
 * 
 * @someTag int $foo descr
 */
function foo(?int $fooBar = 123, \Some\Foo\Bar &$fooBar2, ?string $baz = 'xyz'): int
{
    print_r($fooBar);

    \print_r($fooBar2);

    /** @var class-string<\Some\Foo\Bar> */
    \Some\Foo\Bar::class;

    return 123;
}

$a = static fn() => null;

/** @param 123|345 $fooBar descr */
/** @var int $fooBar */
/** @var $fooBar */

/** 
 * @param int $fooBar1
 * @param int &$fooBar2
 * @param $fooBar5
 * @param &$fooBar6
 * @param int ...$fooBar3
 * @param int ...$fooBar9 description
 * @param int &...$fooBar4
 * @param ...$fooBar7
 * @param &...$fooBar8
 * @param int description
 */
function foo1(
    int $fooBar1,
    int &$fooBar2,
    $fooBar5,
    &$fooBar6,
    int &...$fooBar4,
): void
{
    func_get_args();
}
function foo2(int ...$fooBar3) {}
function foo3(...$fooBar7) {}
function foo4(&...$fooBar8) {}
