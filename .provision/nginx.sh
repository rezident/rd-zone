#!/usr/bin/env bash
apt-get install nginx -y
sed -i 's/user www\-user;/user vagrant;/g' /etc/nginx/nginx.conf
if [ ! -f /vagrant/nginx.conf ]
	then
		cp nginx.conf /vagrant
fi
if [ `grep "^include /vagrant/nginx.conf" /etc/nginx/nginx.conf | wc -l` = 0 ]
	then
		echo "include /vagrant/nginx.conf" >> /etc/nginx/nginx.conf
fi
/etc/init.d/nginx restart