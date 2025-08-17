#!/bin/bash

# Podman 网络问题修复脚本
# 解决 DNS 解析失败和镜像拉取超时问题

echo "=== Podman 网络问题诊断和修复 ==="

# 1. 检查网络连通性
echo "\n1. 检查网络连通性..."
echo "测试外网连接:"
ping -c 3 8.8.8.8

echo "\n测试 DNS 解析:"
nslookup docker.io
nslookup registry-1.docker.io

# 2. 检查当前 registries.conf 配置
echo "\n2. 检查当前 Podman 配置..."
echo "当前 registries.conf 位置:"
find /etc/containers/ ~/.config/containers/ -name "registries.conf" 2>/dev/null

# 3. 备份现有配置
echo "\n3. 备份现有配置..."
mkdir -p ~/.config/containers/
if [ -f ~/.config/containers/registries.conf ]; then
    cp ~/.config/containers/registries.conf ~/.config/containers/registries.conf.backup.$(date +%Y%m%d_%H%M%S)
    echo "已备份现有配置文件"
fi

# 4. 复制新的配置文件
echo "\n4. 应用新的镜像源配置..."
cp /mnt/c/Users/阿rong/Desktop/WSL/registries.conf ~/.config/containers/
echo "已复制新的 registries.conf 配置"

# 5. 验证配置
echo "\n5. 验证 Podman 配置..."
podman info --format="{{.Registries}}"

# 6. 测试镜像拉取
echo "\n6. 测试镜像拉取..."
echo "尝试拉取小镜像进行测试:"
podman pull hello-world

if [ $? -eq 0 ]; then
    echo "\n✅ 网络问题已解决！现在可以尝试拉取 MySQL 镜像:"
    echo "podman pull mysql:8.0"
else
    echo "\n❌ 仍有问题，请检查以下解决方案:"
    echo "\n=== 进一步故障排除 ==="
    
    echo "\n方案1: 使用官方源（绕过镜像）"
    echo "podman pull docker.io/library/mysql:latest --tls-verify=false"
    
    echo "\n方案2: 配置 DNS"
    echo "sudo echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
    echo "sudo echo 'nameserver 114.114.114.114' >> /etc/resolv.conf"
    
    echo "\n方案3: 检查代理设置"
    echo "env | grep -i proxy"
    
    echo "\n方案4: 重启 Podman 服务"
    echo "podman system reset --force"
    echo "podman system service --time=0 &"
fi

echo "\n=== 脚本执行完成 ==="