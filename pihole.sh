#!/bin/bash

case $1 in
  start)
    export IP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"
    export IPV6="$(ip -6 route get 2001:4860:4860::8888 | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')"
    docker-compose up -d pihole
    ;;
  stop)
    docker-compose stop pihole
    docker-compose rm pihole
    ;;
  *)
    echo "Invalid subcommand. Use 'start' or 'stop'"
    ;;
esac
