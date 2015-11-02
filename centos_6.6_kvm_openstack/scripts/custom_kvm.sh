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

# disable firewall
service iptables stop
chkconfig iptables off

