#!/bin/bash

OVPN_PATH="${OVPN_PATH:-"$PWD/volumes/ovpn"}"
NETWORK="${NETWORK:-"vpn-net"}"

ovpn_cmd () {
  docker run --rm -it \
    -v $OVPN_PATH/openvpn:/etc/openvpn \
    kylemanna/openvpn \
    "$@"
}

case $1 in
  init)
    IP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"
    ovpn_cmd ovpn_genconfig -u "udp://$IP"
    ovpn_cmd ovpn_initpki
    ovpn_cmd bash -c "
      sed -i '/dhcp-option/s/^/# /g' /etc/openvpn/openvpn.conf &&
      echo 'push \"dhcp-option DNS pihole\"' >> /etc/openvpn/openvpn.conf
    "
    ;;
  start)
    docker run -d \
      --name ovpn \
      -v $OVPN_PATH/openvpn:/etc/openvpn \
      --network=$NETWORK \
      -p 1194:1194/udp \
      --cap-add=NET_ADMIN \
      --restart always \
      kylemanna/openvpn
    ;;
  stop)
    docker stop ovpn
    docker rm ovpn
    ;;
  cert-create)
    ovpn_cmd easyrsa build-client-full $2 nopass
    ;;
  cert-revoke)
    ovpn_cmd ovpn_revokeclient $2 remove
    ;;
  cert-get)
    ovpn_cmd ovpn_getclient $2 > "$2.ovpn"
    ;;
  *)
    echo "Invalid subcommand. Use 'init', 'start', 'stop', 'cert-create', 'cert-revoke' or 'cert-get'"
    ;;
esac
