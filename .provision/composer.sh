#!/usr/bin/env bash
apt-get install php5-cli -y
php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer
