#!/usr/bin/env bash
if [ -f /usr/bin/nodejs ]
	then exit 0
fi

apt-get install nodejs nodejs-legacy npm -y