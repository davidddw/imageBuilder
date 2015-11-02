# add custom script in here

# remove ip and mac address
rm -fr /etc/udev/rules.d/70-persistent-net.rules
sed -i '/HWADDR=.*/d' /etc/sysconfig/network-scripts/ifcfg-eth0

# enable tty console
echo "ttyS0" >> /etc/securetty

cat <<'EOF' > /etc/init/ttyS0.conf
stop on runlevel [S016]
start on runlevel [2345]
respawn
instance /dev/ttyS0
exec /sbin/mingetty ttyS0
EOF

# Don't edit grub on ppc64
if [ "$(uname -m)" != "ppc64" -a "$(uname -m)" != "ppc64le"] ; then
    if [ -e /boot/grub/grub.conf ] ; then
        sed -i -e 's/rhgb.*/console=ttyS0,115200n8 console=tty0 quiet/' /boot/grub/grub.conf
        cd /boot
        ln -s boot .
    elif [ -e /etc/default/grub ] ; then
        sed -i -e \
            's/GRUB_CMDLINE_LINUX=\"\(.*\)/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8 console=tty0 quiet \1/g' \
            /etc/default/grub
        grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
fi

# disable firewall
service iptables stop
chkconfig iptables off

