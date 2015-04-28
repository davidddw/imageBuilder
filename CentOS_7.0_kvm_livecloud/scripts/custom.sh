# add custom script in here

cat <<'EOF' > /usr/lib/systemd/system/qemu-guest-agent.service
[Unit]
Description=QEMU Guest Agent
BindsTo=dev-virtio\x2dports-org.qemu.guest_agent.0.device
After=dev-virtio\x2dports-org.qemu.guest_agent.0.device

[Service]
UMask=0077
EnvironmentFile=/etc/sysconfig/qemu-ga
ExecStart=/usr/bin/qemu-ga \
  --method=virtio-serial \
  --path=/dev/virtio-ports/org.qemu.guest_agent.0 \
  --blacklist=${BLACKLIST_RPC} \
  -F${FSFREEZE_HOOK_PATHNAME}
StandardError=syslog
Restart=always
RestartSec=0

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /usr/local/var/run/
# wget vm_init
cd /etc/ && wget http://172.16.39.10/09_config/vm_init.sh && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/bin && wget http://172.16.39.10/09_config/qga/qemu-ga.el7 && mv qemu-ga.el7 qemu-ga && chmod +x qemu-ga

# enable tty console
sed -i 's#quiet#quiet console=ttyS0#' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
