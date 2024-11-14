#!/bin/bash

set -eoux pipefail

kubectl port-forward --namespace monitoring deployment/prometheus 9090:9090 --address 0.0.0.0 &
POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000 --address 0.0.0.0 &
