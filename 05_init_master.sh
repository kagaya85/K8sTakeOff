#!/bin/bash

KUBE_VERSION=v1.20.0
IMAGE_REPOSITORY=registry.cn-hangzhou.aliyuncs.com/kagaya
DEV=ens160

# Reset firstly if ran kubeadm init before
kubeadm reset -f

# kubeadm init with calico network
# CONTROL_PLANE_ENDPOINT="$1"

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#considerations-about-apiserver-advertise-address-and-controlplaneendpoint

kubeadm init \
    --kubernetes-version=${KUBE_VERSION} \
    --control-plane-endpoint=$(ifconfig $DEV | sed -n '2p' | awk '{print $2}'):6443 \
    --pod-network-cidr=192.168.0.0/16 \
    --image-repository=${IMAGE_REPOSITORY} \
    --upload-certs

# Make kubectl works
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

cp -p $HOME/.zshrc $HOME/.zshrc.bak$(date '+%Y%m%d%H%M%S')
echo "export KUBECONFIG=$HOME/.kube/config" >>$HOME/.zshrc
source $HOME/.zshrc

# Get cluster information
kubectl cluster-info
