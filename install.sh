SU=doas
HOME_DIR=$HOME
sysinit=(udev-trigger udev-settle udev sysfs procfs iwd fsck devfs)
default=(brightnessctl dbus dhcpcd hostname hwclock loopback mdevd networkmanager polkit seatd udev-postmount elogind)
install_initial() {
	$SU apk add bash doas openrc eudev mdevd networkmanager iwd seatd elogind dhcpcd brightnessctl git pulseaudio polkit
}
install_service() {
	for i in ${sysinit[@]}; do
		$SU rc-update add $i sysinit  
	done
	for i in ${default[@]}; do
		$SU rc-update add $i default
	done
}
install_browser() {
	$SU apk add firefox
	$SU npm install sass -g
}
install_core() {
	$SU apk add linux-lts linux-lts-dev intel-ucode linux-firmware sof-firmware
}
setup_utils() {
	# chmod +s $(which brightnessctl reboot poweroff)
	CUSTOM_SCRIPT=/etc/init.d/randomdis
	if [ ! -f $CUSTOM_SCRIPT ]; then
		$SU cp custom/randomdis $CUSTOM_SCRIPT
	fi
	$SU rc-update add randomdis default
}
setup_user() {
	INIT_DIR=$HOME_DIR/.config/rc/runlevels/sysinit
	if [ ! -d  $INIT_DIR ]; then 
		mkdir -p $INIT_DIR
	fi
	COMMAND='mkdir -p /run/user/$(id -u)/openrc/;touch /run/user/$(id -u)/openrc/softlevel;openrc --user'
	if [ ! -f "$HOME_DIR/.profiles" ] || ! grep -Fq "$COMMAND" "$HOME_DIR/.profiles"; then
		echo "$COMMAND" >> "$HOME_DIR/.profiles"
	fi
	rc-update --user add pipewire sysinit
	rc-update --user add wireplumber sysinit
	rc-update --user add dbus sysinit
	if [ ! -d $HOME_DIR/.config ]; then
		mkdir $HOME_DIR/.config
	fi
	# setup config
	if [ ! -f $HOME_DIR/.config/config_lock ]; then
		cp -r config/* $HOME_DIR/.config
		touch $HOME_DIR/.config/config_lock
		echo "config copied !"
	else
		echo "lock exist, skipping config overwrite ..."
	fi
}
echo "setting up alpine linux ..."
install_initial
$SU bash ./source.sh
$SU bash ./package.sh
install_browser
install_service
install_core
setup_utils
setup_user
echo "setup done !, please reboot your device"


