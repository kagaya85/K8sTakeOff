#!/bin/bash
# Author Kagaya

CALICO_VERSION=v3.21.2
KUBE_VERSION=v1.23.0
KUBE_PAUSE_VERSION=3.6
DEV=eth0
CMD=crictl

echo "change node hostname"
ipname=$(ifconfig $DEV | sed -n '2p' | awk '{print $2}' | sed 's/\./-/g')
nodetype=worker

echo "${ipname}-${nodetype}" >/etc/hostname
echo "127.0.0.1   ${ipname}-${nodetype}" >>/etc/hosts
sysctl kernel.hostname=${ipname}-${nodetype}

echo "start pull calico images"

eval $CMD pull calico/cni:$CALICO_VERSION
eval $CMD pull calico/pod2daemon-flexvol:$CALICO_VERSION
eval $CMD pull calico/node:$CALICO_VERSION
eval $CMD pull calico/kube-controllers:$CALICO_VERSION

echo "start pull kubernetes images"

ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/google_containers

eval $CMD pull $ALIYUN_URL/kube-proxy:"${KUBE_VERSION}"
eval $CMD pull $ALIYUN_URL/pause:"${KUBE_PAUSE_VERSION}"

eval $CMD images
