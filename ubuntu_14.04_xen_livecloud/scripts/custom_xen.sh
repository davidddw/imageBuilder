# add custom script in here

VM_INIT='http://172.16.39.10/Packer/qga/vm_init.sh'

# wget vm_init
cd /etc/ && wget $VM_INIT && chmod +x vm_init.sh
cat << EOF >> /etc/rc.local
if [ -e /dev/xvdd ];then
    rm -rf /tmp/livecloud
    mkdir /tmp/livecloud
    mount /dev/xvdd /tmp/livecloud
    rm -rf /etc/livecloud
    cp -rf /tmp/livecloud /etc/
    umount /tmp/livecloud
    sh /etc/livecloud/config.sh
else
    sh /etc/vm_init.sh
fi
EOF

rm -rf /bin/sh && ln -s /bin/bash /bin/sh

sed -i -e 's/sleep 40/# sleep 40/' -e 's/sleep 59/# sleep 59/' /etc/init/failsafe.conf

# disable firewall
/usr/sbin/service iptables stop
/sbin/chkconfig iptables off

# install xen tools
mount /dev/sr0 /mnt
(echo y) | sh /mnt/Linux/install.sh

# modify grub
sed -i 's#quiet#quiet console=hvc0#' /boot/grub/grub.conf