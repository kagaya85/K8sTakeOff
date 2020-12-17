#!/bin/bash
# Author Kagaya

Tools=(epel-release bind-utils git vim zsh neofetch htop tree unzip ntpdate bridge-utils go)

EpelFile=/etc/yum.repos.d/konimex-neofetch-epel-7.repo

echo "export PS1=\"[%n@$(/sbin/ifconfig ens160 | sed -nr 's/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')]%~%# \"" >>$HOME/.zshrc &&
    source $HOME/.zshrc

# yum -y update
yum -y install wget
# yum 换源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak &&
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &&
    yum clean all &&
    yum makecache

# 添加yum epel
if [ ! -f "$EpelFile" ]; then
    echo -e ">>> Add epel repo <<<\n"
    curl -o $EpelFile https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
fi

# 安装软件
for name in "${Tools[@]}"; do
    echo -e ">>> Install $name <<<\n"
    yum -y install "$name"
done

# 切换zsh
chsh -s /bin/zsh
