#!/usr/bin/env bash
if [ -f /bin/composer ]
	then exit 0
fi

apt-get install php7.0-cli -y
php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer
