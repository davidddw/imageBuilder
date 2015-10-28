# Base install

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

cat <<'EOF' > /etc/yum.repos.d/custom.repo
# yum --disablerepo=\* --enablerepo=centos7,epel7 [command]

[centos7]
name=CentOS-$releasever - Media
baseurl=http://172.16.2.254/00_mirrors/centos7/centos
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[epel7]
name=CentOS-$releasever - Media
baseurl=http://172.16.2.254/00_mirrors/centos7/epel7
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

yum --disablerepo=\* --enablerepo=centos7,epel7 -y install vim openssh-clients wget

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config
