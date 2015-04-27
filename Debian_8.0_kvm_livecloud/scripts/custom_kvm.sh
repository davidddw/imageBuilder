# add custom script in here

# add respawn script
cat <<'EOF' > /etc/init.d/qemu-guest-agent 
#! /bin/sh
### BEGIN INIT INFO
# Provides:          qemu-guest-agent
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: QEMU Guest Agent startup script
# Description:       Start the QEMU Guest Agent if we're running
#                    in a QEMU virtual machine
### END INIT INFO

# Author: Michael Tokarev <mjt@tls.msk.ru>

PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="QEMU Guest Agent"
NAME=qemu-ga
DAEMON=/usr/sbin/$NAME
PIDFILE=/var/run/$NAME.pid

# config
DAEMON_ARGS=""
# default transport
TRANSPORT=virtio-serial:/dev/virtio-ports/org.qemu.guest_agent.0

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/qemu-guest-agent ] && . /etc/default/qemu-guest-agent

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh
. /lib/lsb/init-functions

do_check_transport() {
    method=${TRANSPORT%%:*}; path=${TRANSPORT#*:}
    case "$method" in
        virtio-serial | isa-serial)
        if [ ! -e "$path" ]; then
            log_warning_msg "$NAME: transport endpoint not found, not starting"
            return 1
        fi
        ;;
    esac
}

do_start()
{
    start-stop-daemon -Sq -p $PIDFILE -x $DAEMON --test > /dev/null \
        || return 1
    start-stop-daemon -Sq -p $PIDFILE -x $DAEMON -- --daemonize \
        $DAEMON_ARGS -m "$method" -p "$path" \
        || return 2
}

do_stop()
{
    start-stop-daemon -Kq --retry=TERM/30/KILL/5 -p $PIDFILE --name $NAME
}

case "$1" in
  start)
    do_check_transport || exit 0
    [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" $NAME
    do_start
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
    ;;
  stop)
    [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" $NAME
    do_stop
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
    ;;
  status)
    status_of_proc "$DAEMON" $NAME && exit 0 || exit $?
    ;;
  restart|force-reload) # we do not support reload
    do_check_transport || exit 0
    log_daemon_msg "Restarting $DESC" $NAME
    do_stop
    case "$?" in
        0|1)
            do_start
            case "$?" in
                0) log_end_msg 0 ;;
                1) log_end_msg 1 ;; # Old process is still running
                *) log_end_msg 1 ;; # Failed to start
            esac
            ;;
        *)
            # Failed to stop
            log_end_msg 1
            ;;
    esac
    ;;
  *)
    echo "Usage: /etc/init.d/qemu-guest-agent {start|stop|status|restart|force-reload}" >&2
        exit 3
        ;;
esac
:
EOF

chmod +x /etc/init.d/qemu-guest-agent && chkconfig qemu-guest-agent on
mkdir -p /usr/local/var/run/

# wget vm_init
cd /etc/ && wget http://172.16.39.10/09_config/vm_init.sh && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/sbin && wget http://172.16.39.10/09_config/qemu-ga.deb && mv qemu-ga.deb qemu-ga && chmod +x qemu-ga

# enable tty console
PATH=/sbin:/usr/sbin:/bin:/usr/bin
sed -i -e 's#GRUB_CMDLINE_LINUX=.*$#GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS0,115200n8"#' \
-e 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' \
-e 's#GRUB_CMDLINE_LINUX_DEFAULT="quiet"#GRUB_CMDLINE_LINUX_DEFAULT=""#' /etc/default/grub
/usr/sbin/update-grub


