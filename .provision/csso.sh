#!/usr/bin/env bash
if [ ! -f /usr/bin/nodejs ]
	then ./nodejs.sh
fi

npm install csso -g
