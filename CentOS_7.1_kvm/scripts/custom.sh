# add custom script in here

# enable tty console
sed -i 's#quiet#quiet console=ttyS0#' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg