#!/usr/bin/env bash
apt-get install php5-mysql -y

if [ -f /etc/init.d/php5-fpm ]
    then /etc/init.d/php5-fpm restart
fi