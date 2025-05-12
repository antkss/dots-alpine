sysinit=(udev-trigger udev-settle udev sysfs procfs iwd fsck devfs)
default=(brightnessctl dbus dhcpcd hostname hwclock loopback mdevd networkmanager polkit seatd udev-postmount elogind)
install_initial() {
	apk add bash sudo openrc eudev mdevd networkmanager iwd seatd elogind dhcpcd brightnessctl git pulseaudio polkit
}
install_service() {
	for i in ${sysinit[@]}; do
		rc-update add $i sysinit  
	done
	for i in ${default[@]}; do
		rc-update add $i default
	done
}
install_browser() {
	apk add firefox
	npm install sass -g
}
install_core() {
	apk add linux-lts linux-lts-dev intel-ucode linux-firmware sof-firmware
}
install_initial
./source.sh
bash ./package.sh
install_browser
install_service
install_core

