# add custom script in here

# remove ip and mac address
rm -fr /etc/udev/rules.d/70-persistent-net.rules
rm -fr /etc/sysconfig/network-scripts/ifcfg-eth0

# enable tty console
echo "ttyS0" >> /etc/securetty
echo "S0:2345:respawn:/sbin/agetty ttyS0 115200 linux" >> /etc/inittab

sed -i 's#\(root=.*\)#\1 console=tty0 console=ttyS0,115200n8#' /boot/grub/grub.conf

# disable firewall
service iptables stop
chkconfig iptables off

