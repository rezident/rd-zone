#!/usr/bin/env bash
cat <<EOF >> /home/vagrant/composer-codeception-phpunit-install.sh
#!/usr/bin/env bash
if [ -f /bin/codecept ]
    then
    echo "Уже все установлено"
	exit 0
fi

if [ ! -f /bin/composer ]
    then
    echo "Необходимо установить composer"
    exit 1
fi

composer global require "codeception/codeception"

sudo ln -sf /home/vagrant/.composer/vendor/bin/codecept /bin/codecept
sudo ln -sf /home/vagrant/.composer/vendor/bin/phpunit /bin/phpunit
EOF

chown vagrant:vagrant /home/vagrant/composer-codeception-phpunit-install.sh
chmod 744 /home/vagrant/composer-codeception-phpunit-install.sh