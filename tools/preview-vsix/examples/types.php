<?

abstract class A {
    public int $a1;
    public float $a2;
    public string $a3;
    public bool $a4;
    public array $a5;
    public object $a6;
    public callable $a7;
    public iterable $a8;
    public mixed $a9;
    public null $a10;
    public false $a11;
    public true $a12;
    public void $a13;
    public never $a14;
    public self $a15;
    public static $a16;

    function a(
        int $a1,
        float $a2,
        string $a3,
        bool $a4,
        array $a5,
        object $a6,
        callable $a7,
        iterable $a8,
        mixed $a9,
        null $a10,
        false $a11,
        true $a12,
        void $a13,
        never $a14,
        self $a15,
        static $a16,
    ) { func_get_args(); }

    abstract function _01(): int;
    abstract function _02(): float;
    abstract function _03(): string;
    abstract function _04(): bool;
    abstract function _05(): array;
    abstract function _06(): object;
    abstract function _07(): callable;
    abstract function _08(): iterable;
    abstract function _09(): mixed;
    abstract function _10(): null;
    abstract function _11(): false;
    abstract function _12(): true;
    abstract function _13(): void;
    abstract function _14(): never;
    abstract function _15(): self;
    abstract function _16(): static;
}

abstract class B {
    public INT $a1;
    public FLOAT $a2;
    public STRING $a3;
    public BOOL $a4;
    public ARRAY $a5;
    public OBJECT $a6;
    public CALLABLE $a7;
    public ITERABLE $a8;
    public MIXED $a9;
    public NULL $a10;
    public FALSE $a11;
    public TRUE $a12;
    public VOID $a13;
    public NEVER $a14;
    public SELF $a15;
    public STATIC $a16;

    function a(
        INT $a1,
        FLOAT $a2,
        STRING $a3,
        BOOL $a4,
        ARRAY $a5,
        OBJECT $a6,
        CALLABLE $a7,
        ITERABLE $a8,
        MIXED $a9,
        NULL $a10,
        FALSE $a11,
        TRUE $a12,
        VOID $a13,
        NEVER $a14,
        SELF $a15,
        STATIC $a16,
    ) { func_get_args(); }

    abstract function _01(): INT;
    abstract function _02(): FLOAT;
    abstract function _03(): STRING;
    abstract function _04(): BOOL;
    abstract function _05(): ARRAY;
    abstract function _06(): OBJECT;
    abstract function _07(): CALLABLE;
    abstract function _08(): ITERABLE;
    abstract function _09(): MIXED;
    abstract function _10(): NULL;
    abstract function _11(): FALSE;
    abstract function _12(): TRUE;
    abstract function _13(): VOID;
    abstract function _14(): NEVER;
    abstract function _15(): SELF;
    abstract function _16(): STATIC;
}
