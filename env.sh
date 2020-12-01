#!/bin/bash
# Author Kagaya

Essential=(epel-release git vim docker zsh)
K8s=(kubelet kubeadm kubectl)
Tool=(neofetch htop)
LangEnv=(go python36)
InstallList=(${Essential[@]} ${LangEnv[@]} ${Tool[@]} ${K8s[@]})

EpelFile=/etc/yum.repos.d/konimex-neofetch-epel-7.repo

# 关闭 selinux
setenforce 0 
# yum -y update
yum -y install wget
# yum 换源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak && \
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
yum clean all && \
yum makecache

# 添加yum epel
if [ ! -f "$EpelFile" ]; then
    echo -e ">>> Add epel repo <<<\n"
    curl -o $EpelFile https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
fi

# K8s yum 源
rm -f /etc/yum.repos.d/kubernetes.repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
    http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 安装软件
for name in ${InstallList[@]}; do
    echo -e ">>> Install $name <<<\n"
    yum -y install $name
done

# 切换zsh
chsh -s /bin/zsh

# 安装java环境
if ! type java >/dev/null 2>&1; then
    echo -e ">>> Install oracle jdk 1.8 environment <<<\n"
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u271-b09/61ae65e088624f5aaa0b1d2d801acb16/jdk-8u271-linux-x64.rpm
    yum -y localinstall jdk-8u271-linux-x64.rpm
fi

# 安装maven
if ! type mvn >/dev/null 2>&1; then
    echo -e ">>> Install Apache maven 3.6.3 <<<\n"
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
    tar -zvxf apache-maven-3.6.3-bin.tar.gz -C /opt
    echo -e "\nexport M2_HOME=/opt/apache-maven-3.6.3/" >> ~/.zshrc
    echo 'export PATH="$PATH:$M2_HOME/bin"'>> ~/.zshrc
    source ~/.zshrc
fi
# update-alternatives --set java /usr/java/jdk1.8.0_271-amd64/bin/java
# echo "export JAVA_HOME=/usr/java/jdk1.8.0_271-amd64/jre" >> ~/.zshrc
# source ~/.zshrc

# 配置开机启动
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet

# docker 换源
# mkdir -p /etc/docker
# cat <<EOF > /etc/docker/daemon.json
# {
#     "registry-mirrors": ["https://registry.docker-cn.com"]
# }
# EOF


unset Essential K8s Tool LangEnv InstallList EpelFile
# service docker restart
echo -e ">>> Environment install finish (๑•̀ㅂ•́)و✧  <<<\n"