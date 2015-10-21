#!/usr/bin/env bash
if [ ! -f /usr/bin/gem ]
	then ./ruby.sh
fi

gem update --system
gem install compass
