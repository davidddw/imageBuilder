# add custom script in here

VM_INIT='http://172.16.2.254/Packer/qga/vm_init.sh'
QEMU_GA='http://172.16.2.254/Packer/qga/qemu-ga.el5'

# add respawn script
mkdir -p /usr/var/run/
sed -i '/^qga:/d' /etc/inittab
echo "qga:3:respawn:/usr/bin/qemu-ga --method virtio-serial --path /dev/virtio-ports/org.qemu.guest_agent.0" >> /etc/inittab 

# wget vm_init
cd /etc/ && wget $VM_INIT && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/bin && wget $QEMU_GA && mv qemu-ga.el5 qemu-ga && chmod +x qemu-ga

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

