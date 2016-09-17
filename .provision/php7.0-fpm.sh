#!/usr/bin/env bash
if [ -f /etc/init.d/php7.0-fpm ]
	then exit 0
fi

apt-get install php7.0-fpm -y

sed -i 's/^user = www-data/user = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^group = www-data/group = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^listen.owner = www-data/listen.owner = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^listen.group = www-data/listen.group = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf

if [ ! -f /vagrant/php.ini ]
	then
		touch /vagrant/php.ini
fi

ln -sf /vagrant/php.ini /etc/php/7.0/fpm/conf.d/vagrant.ini

if [ `grep "/etc/init.d/php7.0-fpm restart" /root/autorun.sh | wc -l` = 0 ]
	then
	echo "/etc/init.d/php7.0-fpm restart" >> /root/autorun.sh
fi

/etc/init.d/php7.0-fpm restart