# Base install

systemctl enable sshd
systemctl disable NetworkManager
systemctl enable wicked
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 