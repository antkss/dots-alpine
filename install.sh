sysinit=(udev-trigger udev-settle udev sysfs procfs iwd fsck devfs)
default=(brightnessctl dbus dhcpcd hostname hwclock loopback mdevd networkmanager polkit seatd udev-postmount elogind)
install_initial() {
	apk add bash sudo openrc eudev mdevd networkmanager iwd seatd elogind dhcpcd brightnessctl git pulseaudio
}
install_service() {
	for i in ${sysinit[@]}; do
		rc-update add $i sysinit  
	done
	for i in ${default[@]}; do
		rc-update add $i default
	done
}
install_initial
./source.sh
bash ./package.sh
install_service

