# add custom script in here

# enable tty console
PATH=/sbin:/usr/sbin:/bin:/usr/bin
sed -i -e 's#GRUB_CMDLINE_LINUX=""#GRUB_CMDLINE_LINUX="console=ttyS0 console=ttyS0,115200n8"#' \
-e 's#splash=silent quiet##' /etc/default/grub
/sbin/update-bootloader --refresh


