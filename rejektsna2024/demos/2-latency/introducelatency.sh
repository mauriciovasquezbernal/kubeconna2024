#! /bin/bash

set -ex

kubectl exec curl-client -- tc qdisc add dev eth0 root netem delay 10ms 10ms 100%
#kubectl exec curl-client -- tc qdisc add dev eth0 root netem delay 200ms 200ms 75%
