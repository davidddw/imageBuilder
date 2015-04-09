#!/bin/bash

set -x

: ${BUILD_VERSION:="v$(date +'%Y%m%d')"}
: ${BUILD_NAME:="CentOS-6.6-x86_64"}
export BUILD_NAME
export BUILD_VERSION
/usr/bin/packer-build build template.json

cd builds
qemu-img convert -O raw centos-6.5.qcow2 box.raw
vhd-util convert -s 0 -t 1 -i box.raw -o stagefixed.vhd
vhd-util convert -s 1 -t 2 -i stagefixed.vhd -o ${BUILD_NAME}-${BUILD_VERSION}.vhd

qemu-img convert -c -O qcow2 centos-6.5.qcow2 ${BUILD_NAME}-${BUILD_VERSION}.qcow2
bzip2 ${BUILD_NAME}-${BUILD_VERSION}.vhd
rm -rf centos-6.5.qcow2
echo "==> Generate files:"
find . -type f -printf "==> %f\n"

cd -

echo "Done"
