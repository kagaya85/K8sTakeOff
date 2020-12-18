#!/bin/bash

echo ">>>Please execute this after join the cluster<<<"

echo "Make kubectl works"

mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/kubelet.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
cp -p $HOME/.zshrc $HOME/.zshrc.bak$(date '+%Y%m%d%H%M%S')
echo "export KUBECONFIG=$HOME/.kube/config" >>$HOME/.zshrc
source $HOME/.zshrc

# 验证
echo "kubectl version will show the Client & Server infomation"

kubectl version
