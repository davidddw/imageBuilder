# Base install

/usr/bin/curl -fsS https://www.archlinux.org/mirrorlist/?country=all > /tmp/mirrolist
/usr/bin/grep 'China' -A12 /tmp/mirrolist | grep '^#Server' | sed 's/^#//' > /tmp/mirrolist.50
/usr/bin/rankmirrors -v /tmp/mirrolist.50 | tee /etc/pacman.d/mirrorlist

pacman -S --noconfirm vim python2 wget

sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 