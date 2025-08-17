#!/bin/bash

# Podman 镜像仓库配置脚本

echo "正在配置 Podman 镜像仓库..."

# 创建配置目录
sudo mkdir -p /etc/containers

# 创建 registries.conf 配置文件
sudo tee /etc/containers/registries.conf > /dev/null <<EOF
# 配置镜像仓库
[registries.search]
registries = ['docker.io', 'quay.io', 'registry.fedoraproject.org']

[registries.insecure]
registries = []

[registries.block]
registries = []

# Docker Hub 镜像仓库配置
[[registry]]
prefix = "docker.io"
location = "docker.io"

# 可选：配置国内镜像源加速
[[registry.mirror]]
location = "registry.cn-hangzhou.aliyuncs.com"

[[registry.mirror]]
location = "hub-mirror.c.163.com"

[[registry.mirror]]
location = "mirror.baidubce.com"

# Quay.io 镜像仓库配置
[[registry]]
prefix = "quay.io"
location = "quay.io"

# Red Hat 镜像仓库配置
[[registry]]
prefix = "registry.redhat.io"
location = "registry.redhat.io"
EOF

echo "镜像仓库配置完成！"

# 显示配置文件内容
echo "配置文件内容："
cat /etc/containers/registries.conf

echo ""
echo "现在可以尝试拉取镜像："
echo "podman pull docker.io/mysql:latest"
echo "或者直接使用："
echo "podman pull mysql:latest"