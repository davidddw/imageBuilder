# add custom script in here

# enable tty console
PATH=/sbin:/usr/sbin:/bin:/usr/bin
sed -i -e 's#GRUB_CMDLINE_LINUX=.*$#GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS0,115200n8"#' \
-e 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' \
-e 's#GRUB_CMDLINE_LINUX_DEFAULT="quiet"#GRUB_CMDLINE_LINUX_DEFAULT=""#' /etc/default/grub
/usr/sbin/update-grub

# fix dhcp-client could not set hostname
wget http://ftp.cn.debian.org/debian/pool/main/i/isc-dhcp/isc-dhcp-client_4.3.3-6_amd64.deb \
-O /tmp/isc-dhcp-client_4.3.3-6_amd64.deb && \
dpkg -i /tmp/isc-dhcp-client_4.3.3-6_amd64.deb
wget http://ftp.cn.debian.org/debian/pool/main/i/isc-dhcp/isc-dhcp-common_4.3.3-6_amd64.deb \
-O /tmp/isc-dhcp-common_4.3.3-6_amd64.deb && \
dpkg -i /tmp/isc-dhcp-common_4.3.3-6_amd64.deb

rm -rf /etc/hostname