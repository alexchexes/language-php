<?php

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
     * @param int $fooBar1
     * @param ?array &$fooBar2 Description
     * @param Status $fooBar3 description
     * @param 'json'|123 $fooBar4 (literal unions aren't really handled)
     * @param list<int> &...$fooBar5 Variadic + by-reference
     *
     * @throws \RuntimeException $notTokenized as expected
     * @return array $notTokenized as expected
     */

    abstract public function exmpl(int $fooBar1, ?array &$fooBar2, int $fooBar3, string $fooBar4, ?array &...$fooBar5): array;
}



/*----------------------------*
*         ARRAY SHAPES         *
*-----------------------------*/

/**
 * PHPDoc
 *
 * @param int $var1 Variable 1
 * @param string $var2 Variable 2
 * @param string|null $var3 Variable 3
 * @param (string|null)[] $var4 Variable 4
 * @param array<string|null,int> $var5 Variable 5
 * @param array<string|null, int> $var6 Variable 6
 * @param array{key1:string|null,key2:int} $var7 Variable 7
 * @param array{key1: string|null, key2: int} $var8 Variable 8
 * @param array{
 * 	key1: string|null,
 *  key2: int
 * } $var9 Variable 9
 * @param array{key1: string|null, key2: array<string, int>} $var10 Variable 10
 * @param MyClass $var11 Variable 11
 * @param \MyNameSpace\MyClass $var12 Variable 12
 * @param \MyNameSpace\MyClass|MyOtherClass $var13 Variable 13
 * @param \MyNameSpace\MyClass&\MyNamespace\MyOtherClass $var14 Variable 14
 *
 * @return array{
 * 	key1: string,
 * 	key2: int|null,
 * 	key3: array<int, string>
 *  key4: array{
 * 		subkey1: array {
 * 			subsubkey: string|null
 * 		}
 * 	}
 * } Return value
 * 
 * @throws \Exception sometimes
 */

$foo = 1;