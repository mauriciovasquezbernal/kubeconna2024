#!/bin/bash

set -eoux pipefail

IG_VERSION=v0.34.0
IG_ARCH=amd64

# copy help files
cd /home/iguser
git clone https://github.com/inspektor-gadget/kubecon-na-2024.git

# update and install all dependencies
sudo apt-get update && sudo apt-get install docker docker-compose -y

# prepull builder image
sudo docker pull ghcr.io/inspektor-gadget/ebpf-builder:${IG_VERSION}

# install ig binary
curl -sL https://github.com/inspektor-gadget/inspektor-gadget/releases/download/${IG_VERSION}/ig-linux-${IG_ARCH}-${IG_VERSION}.tar.gz | sudo tar -C /usr/local/bin -xzf - ig

# install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

# install kubectl-gadget
curl -sL https://github.com/inspektor-gadget/inspektor-gadget/releases/download/${IG_VERSION}/kubect-gadget-${IG_ARCH}-${IG_VERSION}.tar.gz | sudo tar -C /usr/local/bin -xzf - ig

# install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# create minikube cluster
minikube start --driver=docker

# inspektor-gadget
kubectl-gadget deploy --image=ghcr.io/inspektor-gadget/inspektor-gadget:latest --otel-metrics-listen --otel-metrics-listen-port=2223

# prometheus
kubectl apply -f https://raw.githubusercontent.com/mauriciovasquezbernal/kubeconna2024/refs/heads/main/rejektsna2024/prometheus/prometheus.yaml?token=GHSAT0AAAAAACYW33XHRVXZ4AIXWAMMF6CYZZS4FFQ
kubectl -n monitoring wait --for=condition=ready pod -l app=prometheus --timeout=300s

# helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# grafana
# from https://medium.com/@akilblanchard09/monitoring-a-kubernetes-cluster-using-prometheus-and-grafana-8e0f21805ea9
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana --set adminPassword=abcd --namespace monitoring
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64

#kubectl port-forward --namespace monitoring deployment/prometheus 9090:9090 &


#export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace monitoring port-forward $POD_NAME 3000 &
