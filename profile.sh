file=/etc/profile.d/openrc-user.sh
if [ ! -f $file ] ; then
	echo "setting up the profile ..."
	install -m 644 ./custom/openrc-user.sh $file
else 
	echo "profile setup exist, skipping ..."
fi
