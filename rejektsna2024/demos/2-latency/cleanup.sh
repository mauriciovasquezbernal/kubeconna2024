#! /bin/bash

set -ex

kubectl-gadget delete network-latency
kubectl delete -f app.yaml
