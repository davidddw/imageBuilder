# Base install


# Fix slow DNS lookups with VirtualBox's DNS proxy:
# https://github.com/mitchellh/vagrant/issues/1172#issuecomment-9438465
echo 'options single-request-reopen' >> /etc/resolv.conf
sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 

cat <<'EOF' > /etc/yum.repos.d/custom.repo
# yum --disablerepo=\* --enablerepo=centos5,epel5 [command]

[centos5]
name=CentOS-$releasever - Media
baseurl=http://10.33.2.254/00_mirrors/centos5/centos
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

[epel5]
name=CentOS-$releasever - Custom
baseurl=http://10.33.2.254/00_mirrors/centos5/epel5
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
EOF

yum --disablerepo=\* --enablerepo=centos5,epel5 -y install kernel python26

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config


