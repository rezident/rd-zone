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

echo "Установка sudo и добавление пользователя vagrant к группе sudo"
apt-get install sudo -y
adduser vagrant sudo
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant

echo "Установка гостевых дополнений VirtualBox"
mount /dev/cdrom /media/cdrom
if [ `ls -la /media/cdrom/ | wc -l` = 3 ]
	then
		echo "Необходимо подключить образ диска Дополнений гостевой ОС"
		exit
fi
apt-get install build-essential module-assistant linux-headers-$(uname -r) -y
m-a prepare
yes|sh /media/cdrom/VBoxLinuxAdditions.run
umount /media/cdrom

if [ `grep 'UseDNS no' /etc/ssh/sshd_config | wc -l` = 0 ]
	then
		echo "UseDNS -> no в конфиг ssh демона"
		echo 'UseDNS no' >> /etc/ssh/sshd_config
fi