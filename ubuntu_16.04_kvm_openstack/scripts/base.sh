cat <<'EOF' > /etc/apt/sources.list
deb http://cn.archive.ubuntu.com/ubuntu/ wily main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ wily-security main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ wily-updates main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ wily-proposed main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ wily-backports main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ wily main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ wily-security main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ wily-updates main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ wily-proposed main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ wily-backports main restricted universe multiverse
EOF

apt-get update
apt-get install -y --force-yes libglib2.0-0 curl python

echo "UseDNS no" >> /etc/ssh/sshd_config
sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 
