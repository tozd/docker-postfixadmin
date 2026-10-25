<?php

// Configuration of the Docker image. Options set here can be overridden by PHP files in /etc/postfixadmin/conf.d/,
// which are included in alphabetical order.

$CONF['configured'] = true;

$CONF['database_type'] = 'sqlite';
$CONF['database_name'] = '/var/lib/postfixadmin/postfixadmin.db';

foreach (glob('/etc/postfixadmin/conf.d/*.php') ?: [] as $file) {
    include $file;
}
