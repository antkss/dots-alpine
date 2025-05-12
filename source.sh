#!/bin/bash
edge=(http://dl-cdn.alpinelinux.org/alpine/edge/main http://dl-cdn.alpinelinux.org/alpine/edge/community http://dl-cdn.alpinelinux.org/alpine/edge/testing)
for i in ${edge[@]}; do
	if [ ! -n "$(cat /etc/apk/repositories | grep $i)" ]; then 
		echo "applying :$i ..."
		echo "$i" >> /etc/apk/repositories
	fi
done
apk update
