#!/bin/bash

VOLUMES_PATH=${VOLUMES_PATH:-"/volumes"}
PIHOLE_PORT=${PIHOLE_PORT:-5555}
NETWORK=${NETWORK:-"vpn-net"}

cp ./pihole.sh /usr/local/bin/pihole
cp ./ovpn.sh /usr/local/bin/ovpn

sed -i "s|PIHOLE_PATH=.*|PIHOLE_PATH=\"$VOLUMES_PATH/pihole\"|g" /usr/local/bin/pihole
sed -i "s|PIHOLE_PORT=.*|PIHOLE_PORT=\"$PIHOLE_PORT\"|g" /usr/local/bin/pihole
sed -i "s|NETWORK=.*|NETWORK=\"$NETWORK\"|g" /usr/local/bin/pihole
sed -i "s|OVPN_PATH=.*|OVPN_PATH=\"$VOLUMES_PATH/ovpn\"|g" /usr/local/bin/ovpn
sed -i "s|NETWORK=.*|NETWORK=\"$NETWORK\"|g" /usr/local/bin/ovpn

cp ./vpnconfig_pihole.service /etc/systemd/system/
cp ./vpnconfig_ovpn.service /etc/systemd/system/

mkdir -p $VOLUMES_PATH/pihole
mkdir -p $VOLUMES_PATH/ovpn

docker network create $NETWORK

/usr/local/bin/ovpn init