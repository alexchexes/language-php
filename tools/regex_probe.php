<?php
declare(strict_types=1);

/*
 * This file should be saved as UTF-8.
 * To run: php regex_probe.php
 */

$cases = [
    // === 1F600 group ===
    ['/\\u{1F600}/',   "'/\\\\u{1F600}/'"],
    ['/\\u{1F600}/u',  "'/\\\\u{1F600}/u'"],
    ['/\u{1F600}/',    "'/\\u{1F600}/'"],
    ['/\u{1F600}/u',   "'/\\u{1F600}/u'"],
    ['/\u1F600/',      "'/\\u1F600/'"],
    ['/\u1F600/u',     "'/\\u1F600/u'"],
    ['/\x{1F600}/',    "'/\\x{1F600}/'"],
    ['/\x{1F600}/u',   "'/\\x{1F600}/u'"],

    ["/\\u{1F600}/",   '"/\\\\u{1F600}/"'],
    ["/\\u{1F600}/u",  '"/\\\\u{1F600}/u"'],
    ["/\u{1F600}/",    '"/\\u{1F600}/"'],
    ["/\u{1F600}/u",   '"/\\u{1F600}/u"'],
    ["/\u1F600/",      '"/\\u1F600/"'],
    ["/\u1F600/u",     '"/\\u1F600/u"'],

    // === 7F group ===
    ['/\\x{7F}/',      "'/\\\\x{7F}/'"],
    ['/\\x7F/',        "'/\\\\x7F/'"],
    ['/\u{7F}/',       "'/\\u{7F}/'"],
    ['/\u{7F}/u',      "'/\\u{7F}/u'"],
    ['/\x{7F}/',       "'/\\x{7F}/'"],
    ['/\x7F/',         "'/\\x7F/'"],

    ["/\\x{7F}/",      '"/\\\\x{7F}/"'],
    ["/\\x7F/",        '"/\\\\x7F/"'],
    ["/\u{7F}/",       '"/\\u{7F}/"'],
    ["/\u{7F}/u",      '"/\\u{7F}/u"'],
    ["/\x{7F}/",       '"/\\x{7F}/"'],
    ["/\x7F/",         '"/\\x7F/"'],

    // === literal emoji ===
    ['/😀/',           "'/😀/'"],
    ['/😀/u',          "'/😀/u'"],
];

/*
 * Test subjects:
 * - "DEL" is 0x7F (invisible), but output shows hex bytes so it's still easy to reason about.
 * - "A" is included as a visible subject if you later replace 7F -> 41 in your patterns.
 */
$subjects = [
    'literal_u_curly'   => "\\u{1F600}",
    'literal_u_plain'   => "\\u1F600",
    'literal_x_curly_7f'=> "\\x{7F}",
    'literal_x_7f'      => "\\x7F",
    'emoji'             => "😀",
    'DEL'               => "\x7F",
    'A'                 => "A",
];

function hex_bytes(string $s): string {
    $hex = strtoupper(bin2hex($s));
    return trim(implode(' ', str_split($hex, 2)));
}

function visible_bytes(string $s): string {
    $out = '';
    $len = strlen($s);

    for ($i = 0; $i < $len; $i++) {
        $b = ord($s[$i]);

        if ($b >= 0x20 && $b <= 0x7E) {
            $out .= $s[$i];
        } elseif ($b === 0x0A) {
            $out .= '\n';
        } elseif ($b === 0x0D) {
            $out .= '\r';
        } elseif ($b === 0x09) {
            $out .= '\t';
        } else {
            $out .= sprintf('\x%02X', $b);
        }
    }

    return $out;
}

function compile_and_test(string $pattern, array $subjects): array {
    $compileWarning = null;

    set_error_handler(function (int $errno, string $errstr) use (&$compileWarning): bool {
        $compileWarning = $errstr;
        return true; // swallow warning so output stays clean
    });

    $r = preg_match($pattern, '', $m);

    restore_error_handler();

    $result = [
        'compile_ok'        => ($r !== false),
        'compile_warning'   => $compileWarning,
        'preg_last_error'   => preg_last_error(),
        'preg_last_error_msg'=> function_exists('preg_last_error_msg') ? preg_last_error_msg() : '',
        'tests'             => [],
    ];

    if (!$result['compile_ok']) {
        return $result;
    }

    foreach ($subjects as $name => $subject) {
        $warn = null;

        set_error_handler(function (int $errno, string $errstr) use (&$warn): bool {
            $warn = $errstr;
            return true;
        });

        $m = [];
        $res = preg_match($pattern, $subject, $m);

        restore_error_handler();

        $result['tests'][$name] = [
            'res'     => $res,
            'match'   => ($res === 1) ? $m[0] : null,
            'warning' => $warn,
            'err'     => function_exists('preg_last_error_msg') ? preg_last_error_msg() : '',
        ];
    }

    return $result;
}

foreach ($cases as [$pattern, $src]) {
    echo "SRC       : {$src}\n";
    echo "PATTERN   : " . visible_bytes($pattern) . "\n";
    echo "PATTERNHEX: " . hex_bytes($pattern) . "\n";

    $info = compile_and_test($pattern, $subjects);

    echo "COMPILE    : " . ($info['compile_ok'] ? 'OK' : 'INVALID') . "\n";

    if (!$info['compile_ok']) {
        echo "WARNING    : " . ($info['compile_warning'] ?? '-') . "\n";
        echo "LAST_ERROR : " . $info['preg_last_error_msg'] . "\n";
    } else {
        foreach (['emoji', 'A', 'DEL', 'literal_u_curly', 'literal_u_plain', 'literal_x_curly_7f', 'literal_x_7f'] as $name) {
            $t = $info['tests'][$name];
            $matched = ($t['res'] === 1)
                ? visible_bytes($t['match']) . ' [' . hex_bytes($t['match']) . ']'
                : '-';

            echo sprintf("  %-18s => %-5s %s\n", $name, var_export($t['res'], true), $matched);
        }
    }

    echo str_repeat('-', 88) . "\n";
}