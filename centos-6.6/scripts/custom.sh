# add custom script in here

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
    [ -d /usr/local/var/run/ ] || mkdir -p /usr/local/var/run/
end script
exec /usr/bin/qemu-ga --method $TRANSPORT_METHOD --path $DEVPATH --logfile $LOGFILE --pidfile $PIDFILE --blacklist $BLACKLIST_RPC
EOF

cd /etc/ && wget http://172.16.39.10/09_config/vm_init.sh && chmod +x vm_init.sh
cd /usr/bin && wget http://172.16.39.10/09_config/qemu-ga && chmod +x qemu-ga

rm -fr /etc/udev/rules.d/70-persistent-net.rules
rm -fr /etc/sysconfig/network-scripts/ifcfg-eth0

