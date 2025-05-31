soft=/run/user/$(id -u)/openrc/softlevel
lock=/tmp/openrc-user-$(id -u)
if [[ ! -f $lock ]]; then
	mkdir -p /run/user/$(id -u)/openrc/;touch $soft;openrc --user
	touch $lock
else
	echo "skip running daemon..."
fi 
