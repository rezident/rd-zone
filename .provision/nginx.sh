#!/usr/bin/env bash
apt-get install nginx -y
sed -i 's/user www\-user;/user vagrant;/g' /etc/nginx/nginx.conf
if [ ! -f /vagrant/nginx.conf ]
	then
		cp nginx.conf /vagrant
fi
if [ `grep "^"$'\t'"include /vagrant/nginx.conf" /etc/nginx/nginx.conf | wc -l` = 0 ]
	then
		sed -i 's/^http {/http {\n\tinclude \/vagrant\/nginx.conf\n/' /etc/nginx/nginx.conf
fi

/etc/init.d/nginx restart