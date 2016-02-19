export ZFSBOOT_DISKS=vtbd0
export nonInteractive="YES"
DISTRIBUTIONS="base.txz kernel.txz"

#!/bin/sh
echo 'WITHOUT_X11="YES"' >> /etc/make.conf
cat >> /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
cat >> /etc/rc.conf <<EOF
ifconfig_vtnet0="DHCP"
sshd_enable="YES"
dumpdev="AUTO"
rpcbind_enable="YES"
nfs_server_enable="YES"
mountd_flags="-r"
EOF

env ASSUME_ALWAYS_YES=1 pkg bootstrap
pkg update
pkg install -y sudo
pkg install -y bash
pkg install -y curl
pkg install -y vim wget
pkg install -y ca_root_nss

ln -sf /usr/local/share/certs/ca-root-nss.crt /etc/ssl/cert.pem

echo -n 'yunshan3302' | pw usermod root -h 0
pw groupadd -n vagrant -g 1000
echo -n 'vagrant' | pw useradd -n vagrant -u 1000 -s /usr/local/bin/bash -m -d /home/vagrant/ -G vagrant -h 0
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /usr/local/etc/sudoers

reboot