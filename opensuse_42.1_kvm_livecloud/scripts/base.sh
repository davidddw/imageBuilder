# Base install

rm -f /etc/zypp/repos.d/openSUSE-13.2-0.repo
rpm --import http://mirror.bit.edu.cn/opensuse/distribution/leap/42.1/repo/oss/gpg-pubkey-307e3d54-4be01a65.asc
rpm --import http://mirror.bit.edu.cn/opensuse/distribution/leap/42.1/repo/oss/gpg-pubkey-3dbdc284-53674dd4.asc
zypper ar http://mirror.bit.edu.cn/opensuse/distribution/leap/42.1/repo/oss/ opensuse-13.2-oss
zypper ar http://mirror.bit.edu.cn/opensuse/distribution/leap/42.1/repo/non-oss/ opensuse-13.2-non-oss
zypper refresh
zypper -n install libgthread-2_0-0
systemctl enable sshd
systemctl disable NetworkManager
systemctl enable wicked
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 