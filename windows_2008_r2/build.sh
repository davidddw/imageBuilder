#!/bin/bash

set -x

: ${BUILD_VERSION:="v$(date +'%Y%m%d%H%M%S')"}
: ${BUILD_NAME:="Windows_2008_R2_SP1"}
: ${VM_NAME:="Windows_2008_R2"}

export BUILD_NAME
export VM_NAME
export BUILD_VERSION

PWD=`pwd`
FILENAME=$VM_NAME
PACKER=/usr/bin/packer-build

if [ -e "${PWD}/disk" ];
then
    rm -rf ${PWD}/disk
fi

if [ ! -e "${PWD}/final_images" ];
then
    mkdir -pv ${PWD}/final_images
fi

$PACKER build template.json

cd disk
#qemu-img convert -O raw $FILENAME box.raw
#vhd-util convert -s 0 -t 1 -i box.raw -o stagefixed.vhd
#vhd-util convert -s 1 -t 2 -i stagefixed.vhd -o ${BUILD_NAME}-${BUILD_VERSION}.vhd
qemu-img convert -c -O qcow2 $FILENAME ${BUILD_NAME}-${BUILD_VERSION}.qcow2
#bzip2 ${BUILD_NAME}-${BUILD_VERSION}.vhd
cd -

mv ${PWD}/disk/${BUILD_NAME}-${BUILD_VERSION}.qcow2 ${PWD}/final_images
#mv ${PWD}/disk/${BUILD_NAME}-${BUILD_VERSION}.vhd.bz2 ${PWD}/final_images
rm -rf ${PWD}/disk
echo "==> Generate files:"
find ${PWD}/final_images -type f -printf "==> %f\n"

echo "Done"