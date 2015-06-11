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
rm -rf /bin/sh && ln -s /bin/bash /bin/sh

# wget qemu_ga
cd /usr/bin && wget http://172.16.39.10/09_config/qga/qemu-ga.deb8 && mv qemu-ga.deb8 qemu-ga && chmod +x qemu-ga

# enable tty console
PATH=/sbin:/usr/sbin:/bin:/usr/bin
sed -i -e 's#GRUB_CMDLINE_LINUX=.*$#GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS0,115200n8"#' \
-e 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' \
-e 's#GRUB_CMDLINE_LINUX_DEFAULT="quiet"#GRUB_CMDLINE_LINUX_DEFAULT=""#' /etc/default/grub
/usr/sbin/update-grub

# delete nic config
sed -i '/eth0/,$d' /etc/network/interfaces

# update linux-4.0
cd /tmp
wget http://10.33.39.10/04_ISO/linux-4.0.tar.gz && \
tar zxf linux-4.0.tar.gz && \
dpkg -i *.deb
rm -fr /tmp/*