cat <<'EOF' > /etc/apt/sources.list
deb http://ftp.cn.debian.org/debian/ wheezy main contrib non-free
deb-src http://ftp.cn.debian.org/debian/ wheezy main contrib non-free
deb http://ftp.cn.debian.org/debian-security/ wheezy/updates main
deb-src http://ftp.cn.debian.org/debian-security/ wheezy/updates main
EOF
apt-get update
apt-get install -y --force-yes chkconfig libglib2.0-0 curl 

cat <<'EOF' > /root/.bashrc
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
force_color_prompt=yes

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
export EDITOR=vim
export VISUAL=vim
EOF

echo "UseDNS no" >> /etc/ssh/sshd_config
sed -i "s/nameserver .*/nameserver 8.8.8.8/" /etc/resolv.conf 