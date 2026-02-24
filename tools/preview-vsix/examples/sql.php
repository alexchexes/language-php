<?php

/*----------------------------*
*      SQL interpolation      *
*-----------------------------*/

$a = "
SELECT * FROM users;
SELECT * FROM schema.users;
SELECT * FROM schema.{$var};
";

$a = "SELECT * FROM users;";
$a = "SELECT * FROM schema.users;";
$a = "SELECT * FROM schema.{$var};";
