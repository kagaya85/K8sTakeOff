#!/bin/bash
# Author Kagaya

CALICO_VERSION=v3.17.1
KUBE_VERSION=v1.20.0
KUBE_PAUSE_VERSION=3.2

echo "start pull calico images"

crictl pull calico/cni:$CALICO_VERSION
crictl pull calico/pod2daemon-flexvol:$CALICO_VERSION
crictl pull calico/node:$CALICO_VERSION
crictl pull calico/kube-controllers:$CALICO_VERSION

echo "start pull kubernetes images"

ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/kagaya

crictl pull $ALIYUN_URL/kube-proxy:"${KUBE_VERSION}"
crictl pull $ALIYUN_URL/pause:"${KUBE_PAUSE_VERSION}"

crictl images
