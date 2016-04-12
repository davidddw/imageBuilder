# add custom script in here

VM_INIT='http://172.16.2.254/Packer/qga/vm_init.sh'
QEMU_GA='http://172.16.2.254/Packer/qga/qemu-ga.sles11'

# add respawn script
cat << 'EOF' > /lib/udev/rules.d/81-qemu-ga.rules
SUBSYSTEM=="virtio-ports", ENV{DEVLINKS}=="*/dev/virtio-ports/org.qemu.guest_agent.0", ACTION=="remove", RUN+="/usr/sbin/rcqemu-ga stop"
SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0", ACTION=="add", RUN+="/usr/sbin/rcqemu-ga start"
EOF

cat <<'EOF' > /usr/sbin/rcqemu-ga 
#!/bin/sh

GA_BIN=/usr/bin/qemu-ga
GA_PIDFILE=/var/run/qemu-ga.pid
PIDS=$(pidofproc $GA_BIN)
CMD="/usr/bin/qemu-ga-d-f/var/run/qemu-ga.pid"

function re_create_pidfile() {
    if [ ! -s $GA_PIDFILE ];then
        if [ ! -z "$PIDS" ];then
            for PID in $PIDS; do
                cmd=`cat /proc/$PID/cmdline`
                if [ "$CMD" == "$cmd" ];then
                    echo $PID >$GA_PIDFILE
                    break
                fi
            done
        fi
fi
}

test -s /etc/rc.status && \
	. /etc/rc.status

test -x $GA_BIN || exit 5

rc_reset

case "$1" in
    start)
        echo -n "Starting qemu-ga "
        if [ -h "/dev/virtio-ports/org.qemu.guest_agent.0" ] ; then
            re_create_pidfile
            if ! checkproc -p $GA_PIDFILE $GA_BIN &> /dev/null; then
                $GA_BIN -d -f $GA_PIDFILE
                rc_status -v
            else
                echo
                echo "qemu guest agent already running."
            fi
        else
            echo
            echo "virtio serial org.qemu.guest_agent.0 not found."
        fi
        ;;
	stop)
        echo -n "Shutting down qemu-ga "
        re_create_pidfile
        killproc -p $GA_PIDFILE -TERM $GA_BIN
        rc_status -v
        ;;
    restart)
        $0 stop
        $0 start
        rc_status
        ;;
    status)
        echo -n "Checking for qemu-ga: "
        re_create_pidfile
        checkproc -p $GA_PIDFILE $GA_BIN
        rc_status -v
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac
EOF

chmod +x /usr/sbin/rcqemu-ga 
/sbin/udevadm control --reload-rules  || :
/sbin/udevadm trigger || :
mkdir -p /usr/var/run/

# wget vm_init
cd /etc/ && wget $VM_INIT && chmod +x vm_init.sh
rm -rf /bin/sh && ln -s /bin/bash /bin/sh

# wget qemu_ga
cd /usr/bin && wget $QEMU_GA && mv qemu-ga.sles11 qemu-ga && chmod +x qemu-ga

# remove ip and mac address
rm -fr /etc/udev/rules.d/70-persistent-net.rules
rm -fr /etc/sysconfig/network/ifcfg-eth0

# enable tty console
PATH=/sbin:/usr/sbin:/bin:/usr/bin
sed -i 's@#S0.*@S0:12345:respawn:/sbin/agetty -L 9600 ttyS0 vt102@' /etc/inittab
echo "ttyS0" >> /etc/securetty
