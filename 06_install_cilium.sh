#!/bin/bash
# Author Kagaya

set -e

echo "install cilimu-cli"
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}

sha256sum --check cilium-linux-amd64.tar.gz.sha256sum

sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin

rm cilium-linux-amd64.tar.gz{,.sha256sum}

echo "start install cilium network"
cilium install

echo "check cilium status"
cilium status --wait

echo "test connectivity"
cilium connectivity test
