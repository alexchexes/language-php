Before publish on npm

1. rewrite in ts
add `pnpm lint` command

2. rewrite node tests in modern test framework
+ add true "golden" fixture with the whole PHP built-in single-word identifiers, by scope (functions, constants, class-likes). Lists generated once with php cli invokation (preferrably under WSL), then may be updated if desired.

3. don't parse args manually, utilize a lib.

4. ...?

10. Add readme 1st section:
"What it can and what it can't do"

a small example

a phrase that starts with "used mainly for ..." (lang grammars, what else can it be, similar? general scope like for which we invented it)
