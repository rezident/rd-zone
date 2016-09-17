#!/usr/bin/env bash
apt-get install -y php7.0-dev git pkg-config build-essential libmemcached-dev
cd /tmp
git clone https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
git checkout php7
phpize
./configure --disable-memcached-sasl
make
make install
echo "extension=memcached.so" > /etc/php/7.0/mods-available/memcached.ini
sudo ln -s /etc/php/7.0/mods-available/memcached.ini /etc/php/7.0/fpm/conf.d/20-memcached.ini
sudo ln -s /etc/php/7.0/mods-available/memcached.ini /etc/php/7.0/cli/conf.d/20-memcached.ini

if [ -f /etc/init.d/php7.0-fpm ]
    then /etc/init.d/php7.0-fpm restart
fi