#!/bin/bash
# Author Kagaya

set -e

# K8s yum 源
rm -f /etc/yum.repos.d/kubernetes.repo
cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
    http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum clean all
yum makecache -y
yum repolist all

sudo yum install -y kubelet-1.23.0 kubeadm-1.23.0 kubectl-1.23.0 --disableexcludes=kubernetes

# Check installed Kubernetes packages
sudo yum list installed | grep kube

sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
