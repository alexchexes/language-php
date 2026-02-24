<?php

/*---------------------------*
*    Regexp interpolation    *
*----------------------------*/

// The following is borrowed from here: https://github.com/RedCMD/regex-syntax-highlighter-vscode/blob/main/syntaxes/tests/test.js *

$r = '/[]/';
$r = '/re[g[G]][e\\]((x)/.source + /rege2 )/';
$r = '/r\e[g[G]]e(x)/';
$r = '/re[g-[G]]e(x)/';
$r = '/^refs\/tags\/([^ ]+) ([0-9a-f]{40}) ([0-9a-f]{40})?$/';
$r = '/^refs\/tags\/([^ ]+)\0\1\000\777\999 ([0-9a-f]{40}) ([0-9a-f]{40})?$/';
$r = '/["\'](module|(text|application)\/(java|ecma)script|text\/babel)["\']/';
$r = "/[\"'](module|(text|application)\/(java|ecma)script|text\/babel)[\"']/";
$r = '/^data:(?<type>[^,]*?),(?<data>[^#]*?)(?:#(?<hash>.*))?$/';
$r = '/^(?:[34][0-8]|9[0-7]|10[0-7]|[0-9]|2[1-5,7-9]|[34]9|5[8,9]|1[0-9])(?:;[349][0-7]|10[0-7]|[013]|[245]|[34]9)?(?:;[012]?[0-9]?[0-9])*;?m$/';
$r = '/(?:[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}|00000000-0000-0000-0000-000000000000)/';
$r = '/^((?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\]))$/';
$r = '/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/';
$r = '/\//';

$r = '/^\w+:\/\//';

$r = [
    '/(?<whitespace>[ \t\r\n]+)/',
    '/(?<comment>\/\/.*$|\/\*.*?\*\/)/',
    '/(?<forwardSlash>\/(?!\s))/', // for some reason, Apple ignores single forward slashes before any non-whitespace token
    '/(?<curlyOpen>{)/',
    '/(?<curlyClose>})/',
    '/(?<parenOpen>\()/',
    '/(?<parenClose>\))/',
    '/(?<stringDouble>"(?:\\.|[^"\\]+)*")/',
    "/(?<stringSingle>'(?:''|[^']+)*')/",
    '/(?<stringUnquoted>[A-Za-z_][A-Za-z0-9_.-]*)/',
    '/(?<float>[+-]?\d*\.\d+)/',
    '/(?<integer>[+-]?(0x[a-fA-F\d]+|0[0-7]+|\d+))/',
    '/(?<boolean>:true|:false)/',
    '/(?<date>@\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [+-]\d{4})/',
    '/(?<assign>=)/',
    '/(?<comma>,)/',
    '/(?<semiColon>;)/',
    '/(?<invalid>.)/',
];

$a = '/\\\xFF/';
$b = '/[.*+\-?^${}()|[\]\\]/';
$c = '/\r\n|\r|\n/';
$d = '/\/\/# sourceMappingURL=[^ ]+$/';
$e = '/<%=\s*([^\s]+)\s*%>/';
$f = '/```suggestion(\u0020*(\r\n|\n))((?<suggestion>[\s\S]*?)(\r\n|\n))?```/';
$g =  '/(?<=^|\s)(?=[a-z])([a-z])(?=.*\1$)\(([^()]*0+)(?<!password|token)\)(?!.*?(password|token))\p{L}(?:(?<=\(\d{3}\))-\1|-\1)(?!\s)/u';


$formats = [
    'color-hex' =>
        '/^#([0-9A-Fa-f]{3,4}|([0-9A-Fa-f]{2}){3,4})$/',
    'date-time' =>
        '/^(\d{4})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9]|60)(\.[0-9]+)?(Z|(\+|-)([01][0-9]|2[0-3]):([0-5][0-9]))$/i',
    'date' =>
        '/^(\d{4})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$/i',
    'time' =>
        '/^([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9]|60)(\.[0-9]+)?(Z|(\+|-)([01][0-9]|2[0-3]):([0-5][0-9]))$/i',
    'email' =>
        '/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}))$/',
    'hostname' =>
        '/^(?=.{1,253}\.?$)[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[-0-9a-z]{0,61}[0-9a-z])?)*\.?$/i',
    'ipv4' =>
        '/^(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$/',
    'ipv6' =>
        '/^((([0-9a-f]{1,4}:){7}([0-9a-f]{1,4}|:))|(([0-9a-f]{1,4}:){6}(:[0-9a-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){5}(((:[0-9a-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){4}(((:[0-9a-f]{1,4}){1,3})|((:[0-9a-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){3}(((:[0-9a-f]{1,4}){1,4})|((:[0-9a-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){2}(((:[0-9a-f]{1,4}){1,5})|((:[0-9a-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){1}(((:[0-9a-f]{1,4}){1,6})|((:[0-9a-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9a-f]{1,4}){1,7})|((:[0-9a-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))$/i',
];

$controlCharacters = '/\cA\ca\cM\cm\cJ\cj\cZ\cz  \c@\c*/';

/*--------------------------*
*        Additional:        *
*---------------------------*/
 
$r = '/(?:^|(?<=<\?php))\s*(namespace)\s+([a-z0-9_\x{7f}-\x{10ffff}\\]+)(?=\s*;)/';

$patterns = [
    '/😀/',            // PCRE sees:   /😀/            VALID            literal UTF-8 bytes in pattern (if source file UTF-8); VALID, byte-level match of 😀 bytes (no UTF mode)
    '/😀/u',           // PCRE sees:   /😀/u           VALID            literal UTF-8 bytes + PCRE UTF-8 mode ; VALID, UTF-8-aware match of 😀

    '/\\u{1F600}/',    // PCRE sees:   /\u{1F600}/      INVALID         (\u unsupported in PHP PCRE)
    '/\\u{1F600}/u',   // PCRE sees:   /\u{1F600}/u     INVALID         /u does NOT enable PCRE \u{...} syntax
    '/\\u1F600/',      // PCRE sees:  
    '/\\u1F600/u',     // PCRE sees:  
    '/\\x{1F600}/',    // PCRE sees:    
    '/\\x{1F600}/u',   // PCRE sees:    
    '/\u{1F600}/',     // PCRE sees:   /\u{1F600}/      INVALID         single-quoted: \u is literal backslash + u 
    '/\u{1F600}/u',    // PCRE sees:   /\u{1F600}/u     INVALID         single-quoted: \u is literal backslash + u, invalid regardless of /u
    '/\u1F600/',       // PCRE sees:   /\u1F600/        INVALID         literal \u and \u is unsupported
    '/\u1F600/u',      // PCRE sees:   /\u1F600/u       INVALID         literal \u and \u is unsupported, regardless of /u
    '/\x{1F600}/',     // PCRE sees:   /\x{1F600}/      INVALID         without /u PHP uses 8-bit non-UTF mode (code point > 0xFF)
    '/\x{1F600}/u',    // PCRE sees:   /\x{1F600}/u     VALID           matches 😀 (U+1F600)
    '/\x1F600/',       // PCRE sees:    
    '/\x1F600/u',      // PCRE sees:    

    "/\\u{1F600}/",    // PCRE sees:   /\u{1F600}/      INVALID         same as '/\\u{1F600}/', PCRE in PHP doesn't support \u{...}
    "/\\u{1F600}/u",   // PCRE sees:   /\u{1F600}/u     INVALID         same as '/\\u{1F600}/u'
    "/\\u1F600/",      // PCRE sees:  
    "/\\u1F600/u",     // PCRE sees:  
    "/\\x{1F600}/",    // PCRE sees:    
    "/\\x{1F600}/u",   // PCRE sees:    
    "/\u{1F600}/",     // PCRE sees:   /😀/             VALID           double-quoted PHP parses \u{1F600} to literal UTF-8 😀 ; PCRE sees /😀/ (byte pattern) -> VALID
    "/\u{1F600}/u",    // PCRE sees:   /😀/u            VALID           PHP parses to literal 😀 ; PCRE sees /😀/u in UTF-8 mode -> VALID
    "/\u1F600/",       // PCRE sees:   /\u1F600/        INVALID         double-quoted PHP does NOT support \uHHHH form (only \u{...}); backslash stays ; PCRE sees /\u1F600/ -> INVALID
    "/\u1F600/u",      // PCRE sees:   /\u1F600/u       INVALID         double-quoted PHP does NOT support \uHHHH form (only \u{...}); backslash stays ; PCRE sees /\u1F600/ -> INVALID
    "/\x{1F600}/",     // PCRE sees:    
    "/\x{1F600}/u",    // PCRE sees:    
    "/\x1F600/",       // PCRE sees:    
    "/\x1F600/u",      // PCRE sees:    

    '/\\x{4A}/',       // PCRE sees:   /\x{4A}/         VALID           single-quoted: \\ -> \ ; PCRE sees /\x{4A}/ -> VALID, matches J (0x4A)
    '/\\x4A/',         // PCRE sees:   /\x4A/           VALID           single-quoted: \\ -> \ ; PCRE sees /\x4A/   -> VALID, matches J (0x4A)
    '/\u{4A}/',        // PCRE sees:   /\u{4A}/         INVALID         single-quoted: \u literal ; PCRE sees /\u{4A}/ -> INVALID (\u unsupported)
    '/\u{4A}/u',       // PCRE sees:   /\u{4A}/u        INVALID         single-quoted: \u literal ; PCRE sees /\u{4A}/ -> INVALID (\u unsupported even with /u)
    '/\x{4A}/',        // PCRE sees:   /\x{4A}/         VALID           PCRE hex escape -> VALID, matches J (0x4A)
    '/\x4A/',          // PCRE sees:   /\x4A/           VALID           PCRE hex escape -> VALID, matches J (0x4A)
    "/\\x{4A}/",       // PCRE sees:   /\x{4A}/         VALID           double-quoted: \\ -> \ ; PCRE sees /\x{4A}/ -> VALID, matches J
    "/\\x4A/",         // PCRE sees:   /\x4A/           VALID           double-quoted: \\ -> \ ; PCRE sees /\x4A/   -> VALID, matches J
    "/\u{4A}/",        // PCRE sees:   /J/              VALID           double-quoted PHP parses \u{4A} to literal J byte ; PCRE sees /<J>/ -> VALID
    "/\u{4A}/u",       // PCRE sees:   /J/u             VALID           literal J byte in pattern plus UTF-8 mode ; VALID
    "/\x{4A}/",        // PCRE sees:   /\x{4A}/         VALID           double-quoted PHP does NOT parse \x{...} (PHP string \x needs 1-2 hex digits, no braces) ; PCRE sees /\x{4A}/ -> VALID
    "/\x4A/",          // PCRE sees:   /J/              VALID           double-quoted PHP parses \x4A to literal J byte ; PCRE sees /<J>/ -> VALID
    
    /*---------------------------*
    *    Not real code points    *
    *----------------------------*/
    '/\\u{1Q600}/',    // PCRE sees:
    '/\\u{1Q600}/u',   // PCRE sees:
    '/\\u1Q600/',      // PCRE sees:
    '/\\u1Q600/u',     // PCRE sees:
    '/\\x{1Q600}/',    // PCRE sees:
    '/\\x{1Q600}/u',   // PCRE sees:
    '/\u{1Q600}/',     // PCRE sees:
    '/\u{1Q600}/u',    // PCRE sees:
    '/\u1Q600/',       // PCRE sees:
    '/\u1Q600/u',      // PCRE sees:
    '/\x{1Q600}/',     // PCRE sees:
    '/\x{1Q600}/u',    // PCRE sees:
    '/\x1Q600/',       // PCRE sees:
    '/\x1Q600/u',      // PCRE sees:

    "/\\u{1Q600}/",    // PCRE sees:
    "/\\u{1Q600}/u",   // PCRE sees:
    "/\\u1Q600/",      // PCRE sees:
    "/\\u1Q600/u",     // PCRE sees:
    "/\\x{1Q600}/",    // PCRE sees:
    "/\\x{1Q600}/u",   // PCRE sees:
    "/\u{1Q600}/",     // PCRE sees:
    "/\u{1Q600}/u",    // PCRE sees:
    "/\u1Q600/",       // PCRE sees:
    "/\u1Q600/u",      // PCRE sees:
    "/\x{1Q600}/",     // PCRE sees:
    "/\x{1Q600}/u",    // PCRE sees:
    "/\x1Q600/",       // PCRE sees:
    "/\x1Q600/u",      // PCRE sees:

    '/\\x{4Q}/',       // PCRE sees:
    '/\\x4Q/',         // PCRE sees:
    '/\u{4Q}/',        // PCRE sees:
    '/\u{4Q}/u',       // PCRE sees:
    '/\x{4Q}/',        // PCRE sees:
    '/\x4Q/',          // PCRE sees:
    "/\\x{4Q}/",       // PCRE sees:
    "/\\x4Q/",         // PCRE sees:
    "/\u{4Q}/",        // PCRE sees:
    "/\u{4Q}/u",       // PCRE sees:
    "/\x{4Q}/",        // PCRE sees:
    "/\x4Q/",          // PCRE sees:
];

/*-----------------------*
*          BUG:          *
*------------------------*/

$r = '/[]/';
$syntax = "is broken here";
// unless we "close" it exactly as this: ]/'
$now = "it's OK";

$r = "/[]/";
$syntax = "is broken here";
// unless we "close" it exactly as this: ]/"
$now = "it's OK";
