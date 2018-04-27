#!/bin/bash

case $1 in
  init)
    IP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"
    docker-compose run --rm ovpn ovpn_genconfig -u "udp://$IP"
    docker-compose run --rm ovpn ovpn_initpki
    ;;
  start)
    docker-compose up -d ovpn
    ;;
  stop)
    docker-compose stop ovpn
    docker-compose rm ovpn
    ;;
  create-cert)
    docker-compose exec ovpn easyrsa build-client-full $2 nopass
    ;;
  revoke-cert)
    docker-compose exec ovpn ovpn_revokeclient $2 remove
    ;;
  get-cert)
    docker-compose exec ovpn ovpn_getclient $2 > "$2.ovpn"
    ;;
  *)
    echo "Invalid subcommand. Use 'init', 'start', 'stop', 'gen-cert', 'revoke-cert' or 'get-cert'"
    ;;
esac
