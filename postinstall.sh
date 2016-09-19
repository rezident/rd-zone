#!/usr/bin/env bash
echo "Добро пожаловать в скрипт постустановки системы Debian testing для Vagrant!"
echo "© Yuri Nazarenko / Rezident / https://github.com/rezident/rd-zone"
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

apt-get install build-essential module-assistant linux-headers-$(uname -r) mc -y
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

echo "Удаление больше не нужных программ"
apt-get -y remove linux-headers-$(uname -r) build-essential module-assistant
apt-get -y autoremove
apt-get -y clean

echo "Установка алиасов командной строки"
LS_ALIAS="alias l='ls -lah --color=auto'"
if [ `grep "^$LS_ALIAS" /home/vagrant/.bashrc | wc -l` = 0 ]
	then
		echo $LS_ALIAS >> /home/vagrant/.bashrc
fi
if [ `grep "^$LS_ALIAS" /root/.bashrc | wc -l` = 0 ]
	then
		echo $LS_ALIAS >> /root/.bashrc
fi

GREP_ALIAS="alias grep='grep --color=auto'"
if [ `grep "^$GREP_ALIAS" /home/vagrant/.bashrc | wc -l` = 0 ]
	then
		echo $GREP_ALIAS >> /home/vagrant/.bashrc
fi
if [ `grep "^$GREP_ALIAS" /root/.bashrc | wc -l` = 0 ]
	then
		echo $GREP_ALIAS >> /root/.bashrc
fi

echo "Создание файла автозапуска"
if [ `grep "/root/autorun.sh" /etc/rc.local | wc -l` = 0 ]
	then
	sed -i '/^exit 0$/d' /etc/rc.local
	cat <<EOF >> /etc/rc.local
if [ -f /root/autorun.sh ]
	then
	while [ ! -f /vagrant/Vagrantfile ]
		do
		sleep 1
	done
	/root/autorun.sh
fi
exit 0
EOF
fi

if [ ! -f /root/autorun.sh ]
	then
	touch /root/autorun.sh
	chmod 744 /root/autorun.sh
fi

PROVISION_RUN="`pwd`/rebuild-provision.sh"
if [ `grep "^$PROVISION_RUN" /root/autorun.sh | wc -l` = 0 ]
	then
		echo "sudo su -c \"cd `pwd`;$PROVISION_RUN\"" >> /root/autorun.sh
fi

ln -sf /vagrant /home/vagrant/project

echo "Зануление свободного места на диске для лучшей упаковки образа"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo "Работа окончена! Для упаковки базового образа используйте команду"
echo "vagrant package --base имя-этой-машины"
echo

exit