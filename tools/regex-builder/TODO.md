# Incorrect behavior:

## 0

for 
```
HEADERBYTES
KEYBYTES
```
`--no-split=BYTES`
produces 
```
(HEADERBYTES|KEYBYTES)
```
though the logic of `--no-split` is to forbid splitting specified word MID-WORD, so not clear why we don't get `(HEADER|KEY)BYTES`


## 1

```
U_MULTIPLE_DECIMAL_SEPARATORS
U_MULTIPLE_DECIMAL_SEPERATORS
```
with default setting `--min-word-split 3` currently produces:
```
DECIMAL_SEP(ARA|ERA)TORS
```
Not clear why option `--split=DECIMAL_SEPA,DECIMAL_SEPE` doesn't allow breaking after `_SEPA` and `_SEPE`, so that we would get
```
DECIMAL_SEP(A|E)RATORS
```
Find reason and fix, OR find what `--split` value would allow to do it.

## 2

```
SKF_AD_ALU_XOR_X
SKF_AD_CPU
SKF_AD_HATYPE
SKF_AD_IFINDEX
SKF_AD_MARK
SKF_AD_MAX
SKF_AD_NLATTR
SKF_AD_NLATTR_NEST
SKF_AD_OFF
SKF_AD_PAY_OFFSET
SKF_AD_PKTTYPE
SKF_AD_PROTOCOL
SKF_AD_QUEUE
SKF_AD_RANDOM
SKF_AD_RXHASH
SKF_AD_VLAN_TAG
SKF_AD_VLAN_TAG_PRESENT
SKF_AD_VLAN_TPID
```

--no-split=SKF_AD_HA

gives:
```
SKF_AD_(
        (ALU_XOR_X|CPU)
        |HATYPE
        |(
          IFINDEX|MARK|MAX
          |NLATTR(_NEST)?
          |OFF|PAY_OFFSET|PKTTYPE|PROTOCOL|QUEUE|RANDOM|RXHASH
          |VLAN_(
                TAG(_PRESENT)?
                |TPID
          )
        )
)
```
beside the fact that we'd expect no split of `SKF_AD_HA` (so it would be `SKF_AD_HATYPE|SKF_AD_(...)`)
It for some reason grouped things starting from IFINDEX, when there is no alteration, prefixes/suffixes or anything.

## 3

if for the same input as #2 we instead specify `--split=SKF_AD_HA`, it just has no effect, while we'd expect `HATYPE` be allowed factored at `HA` which would give us nice grouping with `PKT` like `(HA|PKT)TYPE`.

## 4

--split=SOCKET_ENOT,SOCKET_ENO,SOCKET_E,SOCKET_EAF,SOCKET_EPF
still doesn't allow breaking SOCKET_EAFNOSUPPORT SOCKET_EPFNOSUPPORT so we get (SOCKET_E(AF|PF)NOSUPPORT)

## 5
```sh
pnpm run -s regex-builder for-grammar/input/ext.sockets.txt --split=SOCKET_ENOT,SOCKET_ENO,SOCKET_E --no-split=SOCK_,BLOCK,WANT,QUEUE,CTRUNC,TYPE,OOBINLINE,GESTION,ACCEPT,SUPPORT,EMPTY,REMOTE,PERM,STREAM,AGAIN,L2,2BIG,PROGRESS,ACCES,PIPE,LOOP,SIZE,FILE,DIR,IDRM,EXIST,FAULT,START,LONG,RESET,REMCHG,ABORTED,SOL_,COMM,MAX,RNG,IPV,LINK,IPPRO,MEDIUM,NET,INTR,ADDR,DONT,DEBUG,ROFS,EOF --min-word-split 2 > for-grammar/ext.sockets.re
```
Not merged lines 2BIG|ACCES|ADV / AGAIN|ALREADY / BUSY|CHRNG|COMM although wrap width allows
|SOCKET_E(
         2BIG|ACCES|ADV
         |ADDR(INUSE|NOTAVAIL)
         |(AF|PF|SOCKT)NOSUPPORT
         |AGAIN|ALREADY
         |BAD(E|F|FD|MSG|R|RQC|SLT)
         |BUSY|CHRNG|COMM
         |CONN(ABORTED|REFUSED|RESET)
         |DESTADDRREQ|DQUOT|EXIST|FAULT
         |HOST(DOWN|UNREACH)
         |IDRM|INPROGRESS|INTR|INVAL
         |(NX)?IO
         |IS(CONN|DIR|NAM)
         |L2(HLT|NSYNC)
         |L3(HLT|RST)
         |LNRNG|LOOP|MEDIUMTYPE|MFILE|MLINK|MSGSIZE|MULTIHOP|NAMETOOLONG|NFILE
         |NET(DOWN|RESET|UNREACH)
         |NO(ANO|BUFS|CSI|DATA|DEV|ENT|LCK|LINK|MEDIUM|MEM|MSG|NET|PROTOOPT|SPC|SR|STR|SYS)
         |NOT(BLK|CONN|DIR|EMPTY|SOCK|TY|UNIQ)
         |OPNOTSUPP|PERM|REMCHG
         |(STR)?PIPE
         |PROTO(NOSUPPORT|TYPE)?
         |REMOTE(IO)?
         |RESTART|ROFS|SHUTDOWN|SPIPE|SRMNT
         |TIME(DOUT)?
         |TOOMANYREFS|UNATCH|USERS|WOULDBLOCK|XDEV|XFULL
)


## 6
`--no-split=...,_PRIOR_KNOWLEDGE` doesn't prevents `CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE` from being factored as `|2(_(0|PRIOR_KNOWLEDGE))?` 

with that option `_PRIOR_KNOWLEDGE` shouldn't be ever split (unless `--split=...` doesn't overrides, of course)

`--no-split=2_0` also doesn't gives adequate results

## 7
now it makes
`(READF|WRITEF)UNC_PAUSE`
not clear why common F not captured (`(READ|WRITE)FUNC_PAUSE`).
Problem 2:
even if we add --no-split=FUNC, it doesn't gives expected result and instead becames:
`(READFUNC|WRITEFUNC)_PAUSE`.


## 8
minor bug in balanced formatter: for some inputs (e.g. for-grammar/input/ext.xsl.txt), the very last closing brace is on new line (should be on the same line as last token)

# TODO:

##
When sorting members, sort 8 before 16, and 8FOO before 16BAR ("numeric-prefix"-aware sorting)

## 
Sort groups after or during rebalancing / any other structural changes. For groups like |(...) take first member letter for sort purpose
So that this

B
|X|Y|Z
|(A|X)
|N(X|Y)

|(A|X)
B
|N(X|Y)
|X|Y|Z

note: actualy here we would join B with X|Y|Z as long as wrap limit allows, so it would be:
|(A|X)
|B|X|Y|Z
|N(X|Y)


## 
Forbid weird leftovers like (...)D  (...)E so that `ABORTED BOLD` not get factored as `(...|...)D`.
Though need to check what will this impose on real cases and, if needed, make it configurable / optional. 
But to check we can now allow only endings like digit or _, and see how it goes.
* This shouldn't affect cases when word naturally ends with one letter `..._N`/`..._N_...`

## Allow to forbid split only for endings
allow providing `--no-split-end=ED` so that `CLOSED FAILED REJECTED` not factored like `(CLOS|FAIL|REJECT)ED` while still allowing to break any ED that is not at the end of what we treat as separate "word" (our "word" bounds are _, digits, camel->Case change)

# NICE TO HAVE:

##
replace 0|1|2|3 with [0-3]

## 
allow passing a word, like `CWD`, in a way so that as a result we allow splitting CWD even if such split would normally violate `--min-word-split` threshold. Like here: `MULTICWD|NOCWD` even though `NO` violates `--min-word-split 3`.
This is similar to --split= except that --split (we need to rename it!) targets end of the string (where --split value ends - split is allowed) and the new option will do on both ends, so, to produce the same results with both (`MULTICWD|NOCWD` -> `(MULTI|NO)CWD`):
with current --split: `--split=NO`
with new option: `--new-flag=CWD`
result would be identical. possible name for split: `--split-after` (natural hah? `--split-after=_NO`, clear intent).
And yep, current internal name `forceSplitWords` is misleading anyway.

##
also sometimes we need to specify word that must not be split, but it may be found inside may other words. For example, we're running with --min-word-split 2, and we don't want to factor SET SECURE as SE(T|CURE). But we DO want to still allow factor words CLOSETIME OPENTIME, but with --no-split=SET it becomes impossible since CLOSETIME has SET in it. 
So we come to a conclusion that we need another option that will forbid word to be split if it is "standalone" word like in ST_SET / SET1 / 1SET / noSET or is it mid-word like CLOSETIME.
Actually we instead of adding new option for that, we could simply allow passing regexes, like --no-split='\bSET\b'.

##
Allow providing a dict for those split/no-split flags

## 
Allow specify output file with cli option

##
Allow specify input with cli option