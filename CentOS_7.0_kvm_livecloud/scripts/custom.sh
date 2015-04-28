# add custom script in here


# wget vm_init
cd /etc/ && wget http://172.16.39.10/09_config/vm_init.sh && chmod +x vm_init.sh
# wget qemu_ga
cd /usr/bin && wget http://172.16.39.10/09_config/qga/qemu-ga.el7 && mv qemu-ga.el7 qemu-ga && chmod +x qemu-ga


# enable tty console
sed -i 's#quiet#quiet console=ttyS0#' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
