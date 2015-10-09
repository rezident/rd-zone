#!/usr/bin/env bash

echo "mysql-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections

apt-get install mysql-server -y

/etc/init.d/mysql stop
mkdir -p /vagrant/.provision
mv /var/lib/mysql /vagrant/.provision

sed -i 's/= mysql$/= root/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/= \/var\/lib\/mysql$/= \/vagrant\/.provision\/mysql/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/^User=mysql$/User=root/g' /lib/systemd/system/mysql.service
sed -i 's/^Group=mysql$/Group=root/g' /lib/systemd/system/mysql.service

systemctl daemon-reload

if [ `grep "/etc/init.d/mysql restart" /root/autorun.sh | wc -l` = 0 ]
	then
	echo "/etc/init.d/mysql restart" >> /root/autorun.sh
fi

/etc/init.d/mysql start