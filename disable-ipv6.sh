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
sysctl -p

green_echo "IPv6已禁用。"
