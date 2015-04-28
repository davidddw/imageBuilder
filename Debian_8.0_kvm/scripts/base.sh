sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

cat <<'EOF' > /etc/apt/sources.list
deb http://172.16.39.42/debian wheezy main
EOF
apt-get update
apt-get install -y --force-yes chkconfig libglib2.0-0 curl 

sed -i 's#PermitRootLogin.*#PermitRootLogin yes#' /etc/ssh/sshd_config 

echo "UseDNS no" >> /etc/ssh/sshd_config
