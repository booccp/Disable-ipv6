#!/bin/bash

# 定义绿色输出的函数
green_echo() {
  echo -e "\033[32m$1\033[0m"
}

# 定义红色输出的函数
red_echo() {
  echo -e "\033[31m$1\033[0m"
}

# 检查是否以root用户运行
if [ "$EUID" -ne 0 ]; then
  red_echo "请以root用户运行此脚本。"
  exit 1
fi

# 检查是否已禁用IPv6
if sysctl net.ipv6.conf.all.disable_ipv6 | grep -q "1"; then
  green_echo "IPv6已被禁用。"
  exit 0
fi

# 检查是否包含IPv6
if ! ip a | grep -q "inet6"; then
  green_echo "本机不包含IPv6地址。"
  exit 0
fi

# 禁用IPv6
green_echo "禁用IPv6..."

# 添加或替换配置到 /etc/sysctl.conf
sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.conf
sed -i '/net.ipv6.conf.eth0.disable_ipv6/d' /etc/sysctl.conf

{
  echo "net.ipv6.conf.all.disable_ipv6 = 1"
  echo "net.ipv6.conf.default.disable_ipv6 = 1"
  echo "net.ipv6.conf.lo.disable_ipv6 = 1"
  echo "net.ipv6.conf.eth0.disable_ipv6 = 1"
} >> /etc/sysctl.conf

# 重新加载sysctl配置
sysctl -p &> /dev/null
if [ $? -ne 0 ]; then
  red_echo "重新加载sysctl配置失败。"
  exit 1
fi

green_echo "IPv6已禁用。"
