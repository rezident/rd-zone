#!/usr/bin/env bash
apt-get install nginx -y

sed -i 's/user www-data;/user vagrant;/g' /etc/nginx/nginx.conf
if [ ! -f /vagrant/nginx.conf ]
	then
		cp nginx.conf /vagrant
fi
rm -f /etc/nginx/sites-enabled/default
echo "include /vagrant/nginx.conf;" > /etc/nginx/sites-enabled/vagrant.conf

if [ `grep "/etc/init.d/nginx restart" /root/autorun.sh | wc -l` = 0 ]
	then
	echo "/etc/init.d/nginx restart" > /root/autorun.sh
fi

/etc/init.d/nginx restart

