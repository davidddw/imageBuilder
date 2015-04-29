sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

cat <<'EOF' > /etc/apt/sources.list
deb http://172.16.39.42/debian jessie main
EOF
apt-get update
apt-get install -y --force-yes chkconfig libglib2.0-0 curl 

sed -i 's#PermitRootLogin.*#PermitRootLogin yes#' /etc/ssh/sshd_config 
echo "UseDNS no" >> /etc/ssh/sshd_config
systemctl restart ssh.service

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

alias bcs='find . -name "*.h" -o -name "*.c" -o -name "*.cpp" > cscope.files && cscope -Rbkq -i cscope.files && ctags -R --fields=+lS .'
alias bgrep='find . -regex ".*\.\([ch]\|sh\|py\)" | xargs grep -nr --color=auto'
alias cgrep='find . -regex ".*\.\([ch]\)" | xargs grep -nr --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias hook='scp -p -P 29418 david@10.33.2.200:hooks/commit-msg .git/hooks/'
export EDITOR=vim
export VISUAL=vim
EOF
