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

echo "Настраиваем загрузчик GRUB"
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
EOF
update-grub

cat <<EOF > /etc/network/interfaces
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
EOF

echo "Установка ключа для авторизации для пользователя vagrant"
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Установка NFS"
apt-get -y install nfs-common

echo 'Добро пожаловать в виртуальную машину Debian testing by Yuri Nazarenko / Rezident' > /var/run/motd

echo "Удаление больше не нужных программ"
apt-get -y remove linux-headers-$(uname -r) build-essential git module-assistant
apt-get -y autoremove
apt-get -y clean

echo "Зануление свободного места на диске для лучшей упаковки образа"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo "Работа окончена! Для упаковки базового образа используйте команду"
echo "vagrant package --base имя-этой-машины"
echo

exit