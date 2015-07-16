# add custom script in here

VM_INIT='http://172.16.39.10/Packer/qga/vm_init.sh'
QEMU_GA='http://172.16.39.10/Packer/qga/qemu-ga.el7'

cat <<'EOF' > /usr/lib/systemd/system/qemu-guest-agent.service
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
cd /etc/ && wget $VM_INIT && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/bin && wget $QEMU_GA && mv qemu-ga.el7 qemu-ga && chmod +x qemu-ga

# enable tty console
sed -i 's#quiet#quiet console=ttyS0#' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# remove ip and mac address
rm -fr /etc/udev/rules.d/70-persistent-net.rules
rm -fr /etc/sysconfig/network-scripts/ifcfg-eth0
