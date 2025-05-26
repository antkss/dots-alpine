#!/bin/bash
config=/etc/NetworkManager/NetworkManager.conf
if [ ! -f $config ] || [[ ! -n $(grep -r "# nail" /etc/NetworkManager/NetworkManager.conf) ]]; then
echo "applying config ..."
echo "[main]
plugins=ifupdown,keyfile
managed=true
[device]
wifi.backend=iwd
# nail
" > /etc/NetworkManager/NetworkManager.conf
fi
