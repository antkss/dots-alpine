#!/bin/bash
SU=doas
HOME_DIR=$HOME
sysinit=(udev-trigger udev-settle udev sysfs procfs iwd fsck devfs modules)
default=(brightnessctl dbus dhcpcd hostname hwclock loopback mdevd networkmanager polkit seatd udev-postmount elogind)
install_initial() {
	$SU apk add openrc eudev mdevd 
	$SU apk add bash doas networkmanager iwd seatd elogind dhcpcd brightnessctl git pulseaudio polkit-gnome polkit polkit-elogind
}
install_service() {
	echo "activating rc services..."
	for i in ${sysinit[@]}; do
		$SU rc-update add $i sysinit  
	done
	for i in ${default[@]}; do
		$SU rc-update add $i default
	done
}
install_browser() {
	echo "setting up browser ..."
	$SU apk add firefox
	$SU npm install sass -g
}
install_core() {
	echo "setting up core ..."
	$SU apk add linux-lts linux-lts-dev intel-ucode linux-firmware sof-firmware
	echo "linking kernel ..."
	$SU ln -s /boot/initramfs-lts /boot/initrd -f
	$SU ln -s /boot/vmlinuz-lts /boot/vmlinuz -f
}
setup_utils() {
	echo "setting up utils ..."
	# chmod +s $(which brightnessctl reboot poweroff)
	CUSTOM_SCRIPT=/etc/init.d/randomdis
	if [ ! -f $CUSTOM_SCRIPT ]; then
		$SU cp custom/randomdis $CUSTOM_SCRIPT
	fi
	$SU rc-update add randomdis default
	# some script use /usr/bin/bash
	if [ ! -f /usr/bin/bash ]; then 
		$SU ln -s /bin/bash /usr/bin/bash
	fi
	$SU bash utils.sh
}
setup_user() {
	echo "setting up user ..."
	INIT_DIR=$HOME_DIR/.config/rc/runlevels/sysinit
	if [ ! -d  $INIT_DIR ]; then 
		mkdir -p $INIT_DIR
	fi
	$SU bash ./profile.sh
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
antkss() {
	$SU apk add alany bluetui gcompat-musl gradience hcxdumptool hyprland-git linux-own py3-material-color libglvnd libcava svglib 
	$SU apk add nvidia-src 8821cu-src
	$SU bash fstab.sh
}
echo "setting up alpine linux ..."
$SU bash ./source.sh
install_initial
$SU bash ./package.sh
install_browser
install_service
install_core
setup_utils
setup_user
$SU bash ./network.sh
antkss
echo "setup done !, please reboot your device"


