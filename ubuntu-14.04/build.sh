#!/bin/bash

set -x

: ${BUILD_VERSION:="v$(date +'%Y%m%d')"}
: ${BUILD_NAME:="Ubuntu-14.04.2-x86_64"}
export BUILD_NAME
export BUILD_VERSION
/usr/bin/packer-build build template.json

cd builds
tar zxf ${BUILD_NAME}-${BUILD_VERSION}.box

qemu-img convert -O raw box.img box.raw
vhd-util convert -s 0 -t 1 -i box.raw -o stagefixed.vhd
vhd-util convert -s 1 -t 2 -i stagefixed.vhd -o ${BUILD_NAME}-${BUILD_VERSION}.vhd

qemu-img convert -c -O qcow2 box.img ${BUILD_NAME}-${BUILD_VERSION}.qcow2
bzip2 ${BUILD_NAME}-${BUILD_VERSION}.vhd
rm -rf metadata.json Vagrantfile stagefixed.vhd.bak box.img
echo "==> Generate files:"
find . -type f -printf "==> %f\n"

cd -

echo "Done"
