#!/bin/bash

CALICO_YAML="https://docs.projectcalico.org/v3.17/manifests/calico.yaml"
# CALICO_YAML="./manifests/calico.yaml"

kubectl apply -f ${CALICO_YAML}

# Wait a while to let network takes effect
sleep 30

# Check daemonset
kubectl get ds -n kube-system -l k8s-app=calico-node

# Check pod status and ready
kubectl get pods -n kube-system -l k8s-app=calico-node

# Check apiservice status
kubectl get apiservice v1.crd.projectcalico.org -o yaml
