## Demos Readme

### Deploy IG

```bash
# remember to use binary from right branch
kubectl-gadget deploy --image=ghcr.io/inspektor-gadget/inspektor-gadget:latest
```

### Deploy Prometheus

```bash
kubectl apply -f prometheus/prometheus.yaml
kubectl -n monitoring wait --for=condition=ready pod -l app=prometheus --timeout=300s
```


kubectl port-forward --namespace monitoring deployment/prometheus 9090:9090 &
```

Prometheus is now available on localhost:9090
