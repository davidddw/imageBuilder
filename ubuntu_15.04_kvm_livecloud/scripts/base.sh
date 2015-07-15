
cat <<'EOF' > /etc/apt/sources.list
deb http://mirrors.zju.edu.cn/ubuntu/ vivid main restricted universe multiverse
deb http://mirrors.zju.edu.cn/ubuntu/ vivid-security main restricted universe multiverse
deb http://mirrors.zju.edu.cn/ubuntu/ vivid-updates main restricted universe multiverse
deb http://mirrors.zju.edu.cn/ubuntu/ vivid-proposed main restricted universe multiverse
deb http://mirrors.zju.edu.cn/ubuntu/ vivid-backports main restricted universe multiverse
deb-src http://mirrors.zju.edu.cn/ubuntu/ vivid main restricted universe multiverse
deb-src http://mirrors.zju.edu.cn/ubuntu/ vivid-security main restricted universe multiverse
deb-src http://mirrors.zju.edu.cn/ubuntu/ vivid-updates main restricted universe multiverse
deb-src http://mirrors.zju.edu.cn/ubuntu/ vivid-proposed main restricted universe multiverse
deb-src http://mirrors.zju.edu.cn/ubuntu/ vivid-backports main restricted universe multiverse
EOF

apt-get update
apt-get install -y --force-yes libglib2.0-0 curl python

echo "UseDNS no" >> /etc/ssh/sshd_config
sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 
