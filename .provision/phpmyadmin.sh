#!/usr/bin/env bash

if [ ! -f /etc/init.d/mysql ]
    then mysql-server.sh
fi

if [ ! -f /etc/init.d/nginx ]
    then nginx.sh
fi

if [ ! -f /etc/init.d/php5-fpm ]
    then php5-fpm.sh
fi

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password vagrant" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password vagrant" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password vagrant" | debconf-set-selections

apt-get install phpmyadmin -y

ln -sf `pwd`/phpmyadmin.nginx.conf /etc/nginx/sites-enabled/phpmyadmin.conf

AUTO_AUTH="\$cfg\['Servers'\]\[\$i\]\['auth_type'\] = 'config'";
if [ `grep "^$AUTO_AUTH" /etc/phpmyadmin/config.inc.php | wc -l` = 0 ]
    then
    echo "\$cfg['Servers'][\$i]['auth_type'] = 'config';" >> /etc/phpmyadmin/config.inc.php
    echo "\$cfg['Servers'][\$i]['user'] = 'root';" >> /etc/phpmyadmin/config.inc.php
    echo "\$cfg['Servers'][\$i]['password'] = 'vagrant';" >> /etc/phpmyadmin/config.inc.php
fi

/etc/init.d/nginx restart