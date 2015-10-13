#!/usr/bin/env bash
if [ -f /etc/init.d/tomcat8 ]
	then exit 0
fi

apt-get install tomcat8 -y

rm -rf /var/lib/tomcat8/webapps/*
ln -sf /vagrant/ROOT.war /var/lib/tomcat8/webapps/ROOT.war