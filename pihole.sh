#!/bin/bash

PIHOLE_PATH=${PIHOLE_PATH:-"$PWD/volumes/pihole"}
PIHOLE_PORT=${PIHOLE_PORT:-5555}
PIHOLE_IP=${PIHOLE_IP:-"172.19.0.2"}
NETWORK="${NETWORK:-"vpn-net"}"

case $1 in
  start)
    IP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"
    IPV6="$(ip -6 route get 2001:4860:4860::8888 | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')"
    PASSWD="$2"

    docker run -d \
      --name pihole \
      -e ServerIP="${IP}" \
      -e ServerIPv6="${IPV6}" \
      -e TZ="UTC" \
      -e DNS1="8.8.8.8" \
      -e DNS2="8.8.4.4" \
      -e WEBPASSWORD="${PASSWD}" \
      -v $PIHOLE_PATH/pihole:/etc/pihole \
      -v $PIHOLE_PATH/dnsmasq.d:/etc/dnsmasq.d \
      --net $NETWORK \
      --ip $PIHOLE_IP \
      -p 53:53/tcp \
      -p 53:53/udp \
      -p $PIHOLE_PORT:80 \
      --restart unless-stopped \
      diginc/pi-hole
    ;;
  stop)
    docker stop pihole
    docker rm pihole
    ;;
  *)
    echo "Invalid subcommand. Use 'start' or 'stop'"
    ;;
esac
