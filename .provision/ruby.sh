#!/usr/bin/env bash
if [ -f /usr/bin/gem ]
	then exit 0
fi

apt-get install ruby ruby-dev