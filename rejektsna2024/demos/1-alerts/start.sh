#! /bin/bash

set -ex

kubectl-gadget run -f manifest.yaml --detach \
    --annotate exec:metrics.collect=true,exec:metrics.implicit-counter.name=shell_executions,exec.k8s.namespace:metrics.type=key,exec.k8s.podname:metrics.type=key,exec.k8s.containername:metrics.type=key
