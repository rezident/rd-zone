#!/usr/bin/env bash
if [ -f /etc/init.d/mysql ]
	then exit 0
fi

echo "mysql-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections

apt-get install mysql-server -y

/etc/init.d/mysql stop
mkdir -p /vagrant/.provision
if [ ! -d /vagrant/.provision/mysql ]
	then
	cp -r /var/lib/mysql /vagrant/.provision
fi

sed -i 's/= mysql$/= root/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/= 127.0.0.1$/= 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/= \/var\/lib\/mysql$/= \/vagrant\/.provision\/mysql/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/^User=mysql$/User=root/g' /lib/systemd/system/mysql.service
sed -i 's/^Group=mysql$/Group=root/g' /lib/systemd/system/mysql.service

systemctl daemon-reload

if [ `grep "/etc/init.d/mysql restart" /root/autorun.sh | wc -l` = 0 ]
	then
	echo "/etc/init.d/mysql restart" >> /root/autorun.sh
fi

cat <<EOF > /home/vagrant/.my.cnf
[client]
user=root
password=vagrant
EOF
chown vagrant:vagrant /home/vagrant/.my.cnf

/etc/init.d/mysql start

mysql -e 'GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "vagrant" WITH GRANT OPTION;'