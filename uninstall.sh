#!/bin/bash

VOLUMES_PATH=${VOLUMES_PATH:-"/volumes"}
NETWORK=${NETWORK:-"vpn-net"}

systemctl disable vpnconfig_ovpn
systemctl stop vpnconfig_ovpn
systemctl disable vpnconfig_pihole
systemctl stop vpnconfig_pihole


rm /etc/systemd/system/vpnconfig_ovpn.service
rm /etc/systemd/system/vpnconfig_pihole.service
systemctl daemon-reload


docker network rm $NETWORK

rm /usr/local/bin/ovpn
rm /usr/local/bin/pihole

rm -r $VOLUMES_PATH/ovpn
rm -r $VOLUMES_PATH/pihole
