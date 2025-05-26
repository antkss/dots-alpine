#!/bin/bash
edge=(http://dl-cdn.alpinelinux.org/alpine/edge/main http://dl-cdn.alpinelinux.org/alpine/edge/community http://dl-cdn.alpinelinux.org/alpine/edge/testing https://antkss.github.io/alpine)
for i in ${edge[@]}; do
	if [ ! -n "$(cat /etc/apk/repositories | grep $i)" ]; then 
		echo "applying :$i ..."
		echo "$i" >> /etc/apk/repositories
	fi
done
if [ ! -f /etc/apk/keys/antkss.rsa.pub ]; then
	cd /etc/apk/keys
	wget "https://antkss.github.io/alpine/x86_64/antkss.rsa.pub"
fi
apk update
