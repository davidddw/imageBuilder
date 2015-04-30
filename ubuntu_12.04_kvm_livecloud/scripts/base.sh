apt-get update
apt-get install -y --force-yes chkconfig libglib2.0-0 curl 

echo "UseDNS no" >> /etc/ssh/sshd_config
