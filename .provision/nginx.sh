#!/usr/bin/env bash
if [ '$1' = '' ]
	then
	apt-get install incron nginx -y

	sed -i 's/user www-data;/user vagrant;/g' /etc/nginx/nginx.conf
	if [ ! -f /vagrant/nginx.conf ]
		then
			cp nginx.conf /vagrant
	fi
	rm -f /etc/nginx/sites-enabled/default
	echo "include /vagrant/nginx.conf;" > /etc/nginx/sites-enabled/vagrant.conf
	echo "/vagrant IN_CLOSE_WRITE,IN_NO_LOOP `pwd`/nginx.sh $#" > /etc/incron.d/nginx
	/etc/init.d/nginx restart

	else
	if [ $1 = nginx.conf ]
		then
		/etc/init.d/nginx reload
	fi
fi
