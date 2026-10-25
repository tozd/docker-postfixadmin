<?php

// Creates the database schema in an empty database or applies pending upgrades of the database schema, the same as
// opening setup.php does. Exits with an error if the database schema is not current afterwards.

// Postfix Admin stops with die() on some errors, which exits with status 0, so we check the result on shutdown.
$completed = false;
register_shutdown_function(function () use (&$completed) {
    if (!$completed) {
        fwrite(\STDERR, "\nPostfix Admin database schema could not be upgraded.\n");
        exit(1);
    }
});

chdir('/usr/share/postfixadmin/public');

$upgraded = require '/usr/share/postfixadmin/public/upgrade.php';

$completed = $upgraded && check_db_version(false) >= $min_db_version;
