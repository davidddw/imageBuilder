# add custom script in here

# wget vm_init
cd /etc/ && wget http://172.16.39.10/09_config/vm_init.sh && chmod +x vm_init.sh
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

ln -s /bin/bash /bin/sh

# disable firewall
service iptables stop
chkconfig iptables off

# install xen tools
mount /dev/sr0 /mnt
(echo y) | sh /mnt/Linux/install.sh

# modify grub
sed -i 's#quiet#quiet console=hvc0#' /boot/grub/grub.conf