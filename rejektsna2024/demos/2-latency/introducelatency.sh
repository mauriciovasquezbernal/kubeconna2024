#! /bin/bash

set -ex

#kubectl exec curl-client -- tc qdisc add dev eth0 root netem delay 50ms 50ms 25%
kubectl exec curl-client -- tc qdisc add dev eth0 root netem delay 500ms 500ms 70%
