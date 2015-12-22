# Base install

# Fix slow DNS lookups with VirtualBox's DNS proxy:
# https://github.com/mitchellh/vagrant/issues/1172#issuecomment-9438465
echo 'options single-request-reopen' >> /etc/resolv.conf

cat <<'EOF' > /etc/yum.repos.d/custom.repo
# yum --disablerepo=\* --enablerepo=centos6,epel6 [command]

[centos6]
name=CentOS-$releasever - Media
baseurl=http://172.16.2.254/00_mirrors/centos6/centos
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[epel6]
name=CentOS-$releasever - Custom
baseurl=http://172.16.2.254/00_mirrors/centos6/epel6
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

EOF

yum --disablerepo=\* --enablerepo=centos6,epel6 -y install vim openssh-clients \
wget Terminal Thunar leafpad orage thunar-archive-plugin thunar-volman tumbler \
xfce-utils xfce4-appfinder xfce4-icon-theme xfce4-mixer xfce4-panel tigervnc \
xfce4-power-manager xfce4-session xfce4-session-engines xfce4-settings xfconf \
xfdesktop xfwm4 exo fortune-mod garcon libxfce4ui libxfce4util xfce4-doc \
tigervnc-server firefox flash-plugin xorg-x11-fonts-Type1 xorg-x11-fonts-misc xrdp

yum --disablerepo=\* --enablerepo=centos6,epel6 -y groupinstall Fonts

chkconfig xrdp on

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config
