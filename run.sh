#!/bin/bash -x
set -e
docker build -t squid-in-a-can squid-in-a-can 
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3129 -m comment --comment squid-in-a-can
function cleanup {
iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to 3129 -m comment --comment squid-in-a-can
}
trap cleanup EXIT
docker run --net host -v /var/cache/squid3:/var/cache/squid3 squid-in-a-can
