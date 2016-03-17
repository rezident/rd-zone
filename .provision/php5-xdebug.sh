#!/usr/bin/env bash
apt-get install php5-xdebug -y

if [ -f /etc/init.d/php5-fpm ]
    then /etc/init.d/php5-fpm restart
fi