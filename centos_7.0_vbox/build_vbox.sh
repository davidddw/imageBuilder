#!/bin/bash

set -x

: ${BUILD_VERSION:="v$(date +'%Y%m%d%H%M%S')"}
: ${BUILD_NAME:="CentOS_7.0-x86_64"}
: ${VM_NAME:="centos_7.0"}

export BUILD_NAME
export VM_NAME
export BUILD_VERSION

PWD=`pwd`
FILENAME=${VM_NAME}.ovf
PACKER=/usr/bin/packer

if [ -e "${PWD}/disk" ];
then
    rm -rf ${PWD}/disk
fi

if [ ! -e "${PWD}/final_images" ];
then
    mkdir -pv ${PWD}/final_images
fi

$PACKER build template_vbox.json

mv ${PWD}/${BUILD_NAME}.box ${PWD}/final_images/${BUILD_NAME}-${BUILD_VERSION}.box
rm -rf ${PWD}/disk
echo "==> Generate files:"
find ${PWD}/final_images -type f -printf "==> %f\n"

echo "Done"