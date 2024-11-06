#! /bin/bash

set -ex

# TODO: using the manifest doesn't work because the annotation messes it up!
kubectl-gadget run profile_tcprtt:latest --name network-latency --detach \
    --annotate tcprtt:metrics.collect=true --otel-metrics-name=tcprtt:tcprtt
