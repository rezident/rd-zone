#!/usr/bin/env bash
if [ "$1" = "" ]
	then
	apt-get install nginx -y

	sed -i 's/user www-data;/user vagrant;/g' /etc/nginx/nginx.conf
	if [ ! -f /vagrant/nginx.conf ]
		then
			cp nginx.conf /vagrant
	fi
	rm -f /etc/nginx/sites-enabled/default
	echo "include /vagrant/nginx.conf;" > /etc/nginx/sites-enabled/vagrant.conf

	if [ `grep "/nginx.sh config" /etc/rc.local | wc -l` = 0 ]
		then
			sed -i 's/exit 0/`pwd`/nginx.sh config;exit 0/g' /etc/rc.local
	fi



	/etc/init.d/nginx restart

	else
	if [ "$1" = "config" ]
		then
		while [ ! -f /vagrand/nginx.conf ]
		do sleep 1
		done
		/etc/init.d/nginx reload
	fi
fi
