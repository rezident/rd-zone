#!/usr/bin/env bash
if [ -f /bin/composer ]
	then exit 0
fi

apt-get install php5-cli -y
php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer
