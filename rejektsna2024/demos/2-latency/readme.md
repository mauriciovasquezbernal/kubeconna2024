- Be sure Inspektor Gadget and prometheus is running
- deploy demo app
- run tcprtt to see stats
- introduce latency
- check how latency increases
- use tcpdrop to check why packets are dropped
$ kubectl-gadget run trace_tcpdrop:latest --fields k8s.namespace,k8s.podname,reason
