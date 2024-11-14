#! /bin/bash

set -xe
minikube start --driver=docker

# inspektor-gadget
kubectl-gadget deploy --image=ghcr.io/inspektor-gadget/inspektor-gadget:latest --otel-metrics-listen --otel-metrics-listen-address=0.0.0.0:2223

# prometheus
kubectl apply -f prometheus/prometheus.yaml
kubectl -n monitoring wait --for=condition=ready pod -l app=prometheus --timeout=300s
#kubectl port-forward --namespace monitoring deployment/prometheus 9090:9090 &

# grafana
# from https://medium.com/@akilblanchard09/monitoring-a-kubernetes-cluster-using-prometheus-and-grafana-8e0f21805ea9
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana --set adminPassword=abcd --namespace monitoring
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64
#export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace monitoring port-forward $POD_NAME 3000 &
