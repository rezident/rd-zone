#!/usr/bin/env bash
if [ -f /bin/codecept ]
	then exit 0
fi

if [ ! -f /bin/composer ]
    then ./composer.sh
fi

composer global require "codeception/codeception:*"

ln -sf /root/.composer/vendor/bin/codecept /bin/codecept
ln -sf /root/.composer/vendor/bin/phpunit /bin/phpunit