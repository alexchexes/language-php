#!/bin/bash

php -r '
$groups = [];

$add = function(array $names) use (&$groups) {
  foreach ($names as $name) {
    $r = new ReflectionClass($name);
    if (!$r->isInternal()) continue;
    $ext = $r->getExtensionName() ?: "Core";
    $groups[$ext][] = $name;
  }
};

$add(get_declared_classes());
$add(get_declared_interfaces());
$add(get_declared_traits());

ksort($groups);
foreach ($groups as $ext => $names) {
  $names = array_values(array_unique($names));
  sort($names, SORT_STRING);
  echo "# [$ext]\n";
  foreach ($names as $n) echo $n, "\n";
  echo "\n";
}
'