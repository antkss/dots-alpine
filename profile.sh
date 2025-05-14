export COMMAND='mkdir -p /run/user/$(id -u)/openrc/;touch /run/user/$(id -u)/openrc/softlevel;openrc --user'
if [ ! -f "/etc/profile.d/openrc_user.sh" ] ; then
	echo "setting up the profile ..."
	echo $COMMAND > "/etc/profile.d/openrc_user.sh"
else 
	echo "profile setup exist, skipping ..."
fi
