<?php

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
 * @param ?array{key1: int} $arg
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
