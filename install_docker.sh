#!/bin/bash

# 检测并安装 curl 和 wget
function install_curl_wget() {
    for pkg in curl wget; do
        if ! command -v $pkg &> /dev/null; then
            echo "$pkg 未安装，正在安装..."
            apt-get update
            apt-get install -y $pkg
        else
            echo "$pkg 已安装"
        fi
    done
}

# 安装 Docker 和 docker-compose-plugin
function install_docker() {
    echo "正在安装 Docker..."
    curl -fsSL https://get.docker.com | bash -s docker

    # 设置 Docker 开机启动
    echo "设置 Docker 开机启动..."
    systemctl enable docker

    if ! dpkg -l | grep -q "docker-compose-plugin"; then
        echo "docker-compose-plugin 未安装，正在安装..."
        apt-get update
        apt-get install -y docker-compose-plugin
    else
        echo "docker-compose-plugin 已安装"
    fi
}

# 下载并执行 BBR 脚本
function run_bbr_script() {
    echo "正在下载并执行 BBR 脚本..."
    wget -O /tmp/bbr.sh https://github.com/teddysun/across/raw/master/bbr.sh
    chmod +x /tmp/bbr.sh
    /tmp/bbr.sh
}

# 交互式选择功能
function prompt_user() {
    echo "请选择要执行的功能（可以组合输入，如：123）："
    echo "1) 安装 curl 和 wget"
    echo "2) 安装 Docker 和 docker-compose-plugin"
    echo "3) 执行 BBR 脚本"
    read -p "请输入你的选择： " choice

    if [[ $choice =~ [1-3]+ ]]; then
        if [[ $choice == *"1"* ]]; then
            install_curl_wget
        fi
        if [[ $choice == *"2"* ]]; then
            install_docker
        fi
        if [[ $choice == *"3"* ]]; then
            run_bbr_script
        fi
    else
        echo "无效的选择，请输入 1, 2 或 3 的组合。"
    fi
}

# 执行交互选择
prompt_user
