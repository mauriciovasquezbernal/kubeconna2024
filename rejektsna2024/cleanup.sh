#! /bin/bash

kubectl-gadget undeploy
kubectl delete -f prometheus/prometheus.yml
