# Proper PHPDoc parsing "TODO"

## 1

First of all, as we are about to parse types of arbitrary nesting, complexity, where they may be incomplete (e.g. user not finished typing), we must think how to ensure that, no matter what happens inside PHPDoc (unclosed array/generic shapes with types of any nesting / complexity levels, often multiline, plus any other incomplete PHPDoc syntax), - it never breaks tokenization beyond that PHPDoc block.

I.e. we must always capture starting from `/**` to `*/`, and broken tokenization doesn't leak further than the closing `*/`.

Ideally, incomplete syntax also shouldn't break the whole PHPDoc block when the problem is only in one place, for example, if there is `array { ...anything,multiline... ` without closing `}`, but further there are valid PHPDoc syntax, for example, other tags that have proper syntax.

Can we achieve that at all? Unlike normal code where it is usually possible, there is somewhat complexity added by presense of "stars".

So can we "atomize" PHPDoc parts parsing?

If that even possible, then some ideas / questions:

to detect end of incomplete array or generic shape, can we assume that `bar` in `array{ foo bar` or `array<foo bar` can never be a valid part of type syntax? phpstan, psalm, intelephense, etc.?
That is important as this is the only thing that would also help us detect end of multiline unions with arbitrary placement of the last element, for example:
```php
/**
 * @var int|string|bool|array<int|string|bool|null|'@var'|'>'|sometype>|'@var'|'>'|sometype description
 * 
 * @var int | string | bool | array<int | string | bool | null | '>' | sometype> | '>' | sometype description
 * 
 * @var int 
 * | string 
 * | bool 
 * | array<
 *   int 
 *   | string 
 *   | bool 
 *   | null 
 *   | '@var'
 *   | '>'
 *   | sometype // description inside array shapes is now supported by phpstan IRC, and of course it can have > symbols
 * >
 * | '>'
 * | sometype description
 * 
 * @var int |
 * string |
 * bool |
 * array<int |
 *   string |
 *   bool |
 *   null |
 *   '@var' |
 *   '>' |
 *   sometype // description
 * > |
 * '@var' |
 * '>' |
 * sometype description
 * 
 * @var int |
 * ... |
 * sometype
 * description
 */
```
all must be equivalent, right? Can we parse part from `int` to `sometype` as a type, in all cases, reliably? If we do so, isn't this too broad or too narrow (for example, are there cases where both `foo` and `bar` in `foo bar` are part of a type (except that in string literals) in contrast to our assuption that `bar` is always a beginning of description? if yes, how can we formalize that?)?
Anyway, it's probably easier to look into phpstan/psalm phpdoc parsing then guess (see https://github.com/phpstan/phpdoc-parser)

- Subquestion: Beyond types, are there other PHPDoc constructs (known to people and/or recognizable by phpstan, psalm, anything else - anything we could potentially want to parse now or later) with comparable complexity, arbitary nesting levels?

## 2

PHPDoc block tokens scopes must be split in three sections:
- Summary
- Description
- tags[]

Tags may have Description as well, that may be as complex as the main description section (i.e. contain HTML / markdown, if we ever support that).

Inline tags may be inside tags.

One tag starts at @<tag> and ands at the next @<tag> (BTW, may there be other valid endings?), except @<tag> inside string literals in types, fenced or inline code blocks, etc (what exaclty "etc"?).

Tags may be inline, we should remember that - they may happen to be found inside first line that is considered to be a summary, than still may be normal description and tags afterwards.

We will allow tokenizing any `@someTag` as tag,

...

## 3

Will we ever be able to embed other syntax grammar for example in fenced blocks, like here?
```php
/** 
 * Example:
 * ```ts
 * type Foo =
 * | 1
 * | 2
 * | 3 // comment in ts code
 * ```
 */
```
? can we hand over typescript grammar parsing to real typescript syntax?
Probably not (because of "stars"), and if not, can we (and should we) try hand over to typescript grammar each line separately?
That could make sense in many cases, like 
```php
/** 
 * Example:
 * ```js
 * const foo = [1, 2, 3];
 * const bar = new MyClass(1, 2, 3);
 * ```
 */
```
- here each line inside fenced js code block is a finished part of code that could be parsed by js grammar, right?
But should we do that? It will be broken highlight in cases like this:
```php
/** 
 * Example:
 * ```js
 * const foo = [
 *   1,
 *   2,
 *   3
 * ];
 * ```
 */
```
but may this be acceptable? Given that usully markdown code blocks inside PHPDoc are simple examples and even if some may be broken, in many other cases there would be pretty highlighting for simple cases code... Embed / interpolated grammars are still far from ideal in so many cases so should we sacrifice that ability with "all or nothing" approach? ("either proper embed tokenization or no embed tokenization at all")?
But hmm..., there might be other conceptual problem with embed syntax in phpdoc specifically, because, in my personal case, I like that the whole phpdoc including any keywords, types, any recognized / highlighted syntax in it, is not the same brightness / color as normal code, i.e. I want it to be pale / semi-opaque. So in my personal theme, I adjusted all currently recognized keywords inside PHPDoc to match that preference. But is there ability to do that for the whole embed section? If not, beyond that we might enable somewhat broken highlighting, we will make it non-disablable, don't we?
Need to gather info on this point. 
Though probably first thing to do is to simply tokenized fenced code blocks as an atomic unit, without any further tokenization, and leave us space to parse their contents isolatedly in future, if we ever want to. Once again, in such case, incomplete syntax inside such fenced blocks shouldn't broke the whole PHPDoc - often example code may be intentionally incomplete.


## 4 Test corpus
How do we collect all possible, ever existing PHPDoc syntax examples? I have some in my D:\repos\syntax-examples\examples\php\phpdoc (https://github.com/alexchexes/syntax-examples/tree/master/examples/php/phpdoc) but they are naive and ad-hoc, though while gathering them I found that it is really easy to miss something like int[][] (nested array form supported at least by php intelephense, maybe some other tools - was absent in, for example, tree-sitter test corpus despite it has many array forms).
So how do we prepare examples, so that we can see them in our editor and:
- assess current tokenization visually
- see what's missing
- then decide on priorities:
  - what is really used and must be improved / added at the first place
  - what is "some day"
  - what is "nice to have"
  - and what is not even worth trying to add.
- Then take parts of it for our tests suite.
- Then, after some features added, see what's left untokenized and what we'll take next.
- Plus make those examples complex enough so that if we screwed up somewhere (like the mentioned unclosed array / generic brackets breaking whole file or whole PHPDoc), we see it visually in case we missed some test case.
That would not probably be part of this repo, just for our convenience under personal "syntax-examples/examples/php/phpdoc"...
