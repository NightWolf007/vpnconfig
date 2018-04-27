#!/bin/bash

DEFAULT_PIHOLE_PATH="$PWD/volumes/pihole"
PIHOLE_PATH=${PIHOLE_PATH:-$DEFAULT_PIHOLE_PATH}

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
      --network="vpn-net" \
      -p 53:53/tcp \
      -p 53:53/udp \
      -p 5555:80 \
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
