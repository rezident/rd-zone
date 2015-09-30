#!/usr/bin/env bash
echo "Добро пожаловать в скрипт постустановки системы Debian testing для Vagrant!"
echo "© Yuri Nazarenko / Rezident / https://github.com/rezident1307/rd-zone"
echo

if [ $USER != root ]
	then
		echo "Возможно запустить только из под суперпользователя"
		exit
fi

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y
