# add custom script in here

# add respawn script
cat <<'EOF' > /lib/systemd/system/qemu-guest-agent.service
[Unit]
Description=QEMU Guest Agent
BindsTo=dev-virtio\x2dports-org.qemu.guest_agent.0.device
After=dev-virtio\x2dports-org.qemu.guest_agent.0.device

[Service]
UMask=0077
ExecStart=/usr/bin/qemu-ga \
  --method=virtio-serial \
  --path=/dev/virtio-ports/org.qemu.guest_agent.0 \
  --blacklist=guest-file-open,guest-file-close,guest-file-read,guest-file-write,guest-file-seek,guest-file-flush
StandardError=syslog
Restart=always
RestartSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl enable qemu-guest-agent.service
mkdir -p /usr/local/var/run/

# wget vm_init
cd /etc/ && wget http://172.16.39.10/09_config/vm_init.sh && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/bin && wget http://172.16.39.10/09_config/qga/qemu-ga.ubuntu14 && mv qemu-ga.ubuntu14 qemu-ga && chmod +x qemu-ga

# enable tty console
PATH=/sbin:/usr/sbin:/bin:/usr/bin
sed -i -e 's#GRUB_CMDLINE_LINUX=.*$#GRUB_CMDLINE_LINUX="text console=tty1 console=ttyS0,115200n8"#' \
-e 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' \
-e 's#GRUB_CMDLINE_LINUX_DEFAULT="quiet"#GRUB_CMDLINE_LINUX_DEFAULT=""#' /etc/default/grub
update-grub

cat <<'EOF' > /etc/init/ttyS0.conf
# ttyS0 - getty
#
# This service maintains a getty on tty1 from the point the system is
# started until it is shut down again.

start on stopped rc RUNLEVEL=[2345] and (
            not-container or
            container CONTAINER=lxc or
            container CONTAINER=lxc-libvirt)

stop on runlevel [!2345]

respawn
exec /sbin/getty -8 115200 ttyS0
EOF