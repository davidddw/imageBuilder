# add custom script in here

VM_INIT='http://172.16.2.254/Packer/qga/vm_init.sh'
QEMU_GA='http://172.16.2.254/Packer/qga/qemu-ga.el6'

# add respawn script
cat <<'EOF' > /etc/init/qemu-ga.conf 
# qemu-ga
start on runlevel [2345]
stop on runlevel [016]

respawn
env TRANSPORT_METHOD="virtio-serial"
env DEVPATH="/dev/virtio-ports/org.qemu.guest_agent.0"
env LOGFILE="/var/log/qemu-ga/qemu-ga.log"
env PIDFILE="/var/run/qemu-ga.pid"
env BLACKLIST_RPC="guest-file-open guest-file-close guest-file-read guest-file-write guest-file-seek guest-file-flush"

pre-start script
    [ -d /var/log/qemu-ga ] || mkdir -p /var/log/qemu-ga
    [ -d /usr/var/run/ ] || mkdir -p /usr/var/run/
end script
exec /usr/bin/qemu-ga --method $TRANSPORT_METHOD --path $DEVPATH --logfile $LOGFILE --pidfile $PIDFILE --blacklist $BLACKLIST_RPC
EOF

# wget vm_init
cd /etc/ && wget $VM_INIT && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/bin && wget $QEMU_GA && mv qemu-ga.el6 qemu-ga && chmod +x qemu-ga

# remove ip and mac address
rm -fr /etc/udev/rules.d/70-persistent-net.rules
rm -fr /etc/sysconfig/network-scripts/ifcfg-eth0

# enable tty console
echo "ttyS0" >> /etc/securetty

cat <<'EOF' > /etc/init/ttyS0.conf
stop on runlevel [S016]
start on runlevel [2345]
respawn
instance /dev/ttyS0
exec /sbin/mingetty ttyS0
EOF

# disable firewall
service iptables stop
chkconfig iptables off

