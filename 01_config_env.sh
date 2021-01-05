#!/bin/bash

# config time
echo "###############################################"
echo "Config Time Zone"
cp -p $HOME/.zshrc $HOME/.zshrc.bak$(date '+%Y%m%d%H%M%S')
echo "TZ='Asia/Shanghai'; export TZ" >>$HOME/.zshrc
source $HOME/.zshrc

ntpdate -u cn.ntp.org.cn

echo "###############################################"
echo "Stop firewalld"
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 关闭 selinux
echo "###############################################"
echo "Disable SELinux"
sudo getenforce

sudo setenforce 0
sudo cp -p /etc/selinux/config /etc/selinux/config.bak$(date '+%Y%m%d%H%M%S')
sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

sudo getenforce

# Turn off Swap
echo "###############################################"
echo "Turn off Swap"
free -m
sudo cat /proc/swaps

sudo swapoff -a

sudo cp -p /etc/fstab /etc/fstab.bak$(date '+%Y%m%d%H%M%S')
sudo sed -i "s/\/dev\/mapper\/rhel-swap/\#\/dev\/mapper\/rhel-swap/g" /etc/fstab
sed -i "s/\/dev\/mapper\/centos-swap/\#\/dev\/mapper\/centos-swap/g" /etc/fstab
sudo mount -a

free -m
sudo cat /proc/swaps

# Setup iptables (routing)
echo "###############################################"
echo "Setup iptables (routing)"
modprobe br_netfilter
sudo cat <<EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.ipv4.ip_forward = 1
EOF

echo "###############################################"
echo "config nfs"
# echo "/data   10.176.120.0/255.255.248.0(rw,no_root_squash,no_subtree_check)" >/etc/exports
sudo systemctl enable nfs
sudo systemctl start nfs

sudo sysctl --system

# Check ports
echo "###############################################(每一项不应该有输出)"
echo "Check API server port(s)"
netstat -nlp | grep "8080\|6443"

echo "Check ETCD port(s)"
netstat -nlp | grep "2379\|2380"

echo "Check port(s): kublet, kube-scheduler, kube-controller-manager"
netstat -nlp | grep "10250\|10251\|10252"
