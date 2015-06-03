# Base install

rm -f /etc/zypp/repos.d/openSUSE-12.3-0.repo
rpm --import http://mirror.bit.edu.cn/opensuse/distribution/12.3/repo/oss/gpg-pubkey-3dbdc284-4be1884d.asc
rpm --import http://mirror.bit.edu.cn/opensuse/distribution/12.3/repo/oss/gpg-pubkey-307e3d54-4be01a65.asc
zypper ar http://mirror.bit.edu.cn/opensuse/distribution/12.3/repo/oss/ opensuse-12.3-oss
zypper ar http://mirror.bit.edu.cn/opensuse/distribution/12.3/repo/non-oss/ opensuse-12.3-non-oss
zypper refresh
zypper -n install libgthread-2_0-0
systemctl enable sshd
systemctl enable wicked
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 