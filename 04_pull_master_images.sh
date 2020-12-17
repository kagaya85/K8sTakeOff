#!/bin/bash
# Author Kagaya

CALICO_VERSION=v3.17.1
KUBE_VERSION=v1.20.0
KUBE_PAUSE_VERSION=3.2
ETCD_VERSION=3.4.13-0
CORE_DNS_VERSION=1.7.0
DEV=ens160

echo "change master hostname"
ipname=$(ifconfig $DEV | sed -n '2p' | awk '{print $2}' | sed 's/\./-/g')
nodetype=master

echo "${ipname}-${nodetype}" >/etc/hostname
echo "127.0.0.1   ${ipname}-${nodetype}" >>/etc/hosts
sysctl kernel.hostname=${ipname}-${nodetype}

echo "start pull calico images"

crictl pull calico/cni:$CALICO_VERSION
crictl pull calico/pod2daemon-flexvol:$CALICO_VERSION
crictl pull calico/node:$CALICO_VERSION
crictl pull calico/kube-controllers:$CALICO_VERSION

echo "start pull kubernetes images"

ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/kagaya

images=(
    kube-proxy:"${KUBE_VERSION}"
    kube-scheduler:"${KUBE_VERSION}"
    kube-controller-manager:"${KUBE_VERSION}"
    kube-apiserver:"${KUBE_VERSION}"
    pause:"${KUBE_PAUSE_VERSION}"
    etcd:"${ETCD_VERSION}"
    coredns:"${CORE_DNS_VERSION}"
)

for imageName in "${images[@]}"; do
    crictl pull $ALIYUN_URL/"$imageName"
done

crictl images
