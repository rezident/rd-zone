#!/usr/bin/env bash
apt-get install php5-xdebug -y
ln -sf /etc/php5/conf-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini
ln -sf /etc/php5/conf-available/xdebug.ini /etc/php5/fpm/conf.d/20-xdebug.ini

if [ -f /etc/init.d/php5-fpm ]
    then /etc/init.d/php5-fpm restart
fi