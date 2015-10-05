#!/usr/bin/env bash
apt-get install php5-fpm -y

sed -i 's/user = www-data;/user = vagrant;/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/group = www-data;/group = vagrant;/g' /etc/php5/fpm/pool.d/www.conf

if [ ! -f /vagrant/php.ini ]
	then
		touch /vagrant/php.ini
fi

ln -sf /vagrant/php.ini /etc/php5/fpm/conf.d/vagrant.ini

/etc/init.d/php5-fpm restart