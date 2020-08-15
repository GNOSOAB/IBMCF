#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

clone_repo(){
    echo "Step 1: 初始化应用"
    git clone https://github.com/nkxingxh/IBMCF
    cd IBMCF
    git submodule update --init --recursive
    cd cloudreve-cf/cloudreve
    chmod +x *
    cd ${SH_PATH}/IBMCF/cloudreve-cf
    echo "初始化完成"
}

create_mainfest_file(){
    echo "Step 2: 配置应用"
    read -p "请输入你的应用名称：" IBM_APP_NAME
    echo "应用名称：${IBM_APP_NAME}"
    read -p "请输入你的应用内存大小(默认256)：" IBM_MEM_SIZE
    if [ -z "${IBM_MEM_SIZE}" ];then
	IBM_MEM_SIZE=256
    fi
    echo "内存大小：${IBM_MEM_SIZE}"

    cat >  ${SH_PATH}/IBMCF/cloudreve-cf/manifest.yml  << EOF
    applications:
    - path: .
      name: ${IBM_APP_NAME}
      random-route: true
      memory: ${IBM_MEM_SIZE}M
EOF

     echo "配置完成"
}

install(){
    echo "Step 3: 安装应用"
    ibmcloud target --cf
    #ibmcloud cf install
    ibmcloud cf push
    echo "安装完成"
}

clone_repo
create_mainfest_file
install
exit 0