#!/usr/bin/env bash
apt-get install php7.0-pgsql -y

if [ -f /etc/init.d/php7.0-fpm ]
    then /etc/init.d/php7.0-fpm restart
fi