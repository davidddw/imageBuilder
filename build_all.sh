#!/bin/bash

set -x

cd centos_6.5_kvm_livecloud
sh build_kvm.sh

cd centos_6.6_kvm_livecloud
sh build_kvm.sh

cd centos_7.0_kvm_livecloud
sh build_kvm.sh

cd debian_7.8_kvm_livecloud
sh build_kvm.sh

cd debian_8.0_kvm_livecloud
sh build_kvm.sh

cd ubuntu_12.04_kvm_livecloud
sh build_kvm.sh

cd ubuntu_14.04_kvm_livecloud
sh build_kvm.sh

cd ..


echo "Done"