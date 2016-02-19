#!/bin/bash

set -x

mkdir final

cd centos_6.5_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

cd centos_6.7_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

cd centos_7.0_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

cd debian_7.x_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

cd debian_8.x_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

cd ubuntu_12.04_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

cd ubuntu_14.04_kvm_livecloud
sh build_kvm.sh
mv final_images/* ../final
cd -

echo "==> Generate files:"
find final -type f -printf "==> %f\n"


echo "Done"