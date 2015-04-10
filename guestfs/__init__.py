#!/usr/bin/env python
# Example showing how to create a disk image.

import guestfs

g = guestfs.GuestFS(python_return_dict=True)
g.set_trace(1)
output = '/opt/imageBuilder/centos-6.6/final_images/CentOS-6.6-x86_64-v20150409.qcow2'
g.add_drive(output)
g.launch()
g.mount_options("", "/dev/sda", "/")
g.upload('/etc/resolv.conf', '/boot')
g.sync()
g.umount_all()
g.shutdown()
g.close()

# Attach the disk image to libguestfs.
g.add_drive_opts(output, format="raw", readonly= 0)

# Run the libguestfs back-end.
g.launch()
 
 # Get the list of devices.  Because we only added one drive
 # above, we expect that this list should contain a single
 # element.
 devices = g.list_devices ()
 assert (len (devices) == 1)
 
 # Partition the disk as one single MBR partition.
 g.part_disk (devices[0], "mbr")
 
 # Get the list of partitions.  We expect a single element, which
 # is the partition we have just created.
 partitions = g.list_partitions ()
 assert (len (partitions) == 1)
 
 # Create a filesystem on the partition.
 g.mkfs ("ext4", partitions[0])
 
 # Now mount the filesystem so that we can add files.
 g.mount (partitions[0], "/")
 
 # Create some files and directories.
 g.touch ("/empty")
 message = "Hello, world\n"
 g.write ("/hello", message)
 g.mkdir ("/foo")
 
# This one uploads the local file /etc/resolv.conf into
# the disk image.
g.upload ("/etc/resolv.conf", "/foo/resolv.conf")

# Because we wrote to the disk and we want to detect write
# errors, call g.shutdown.  You don't need to do this:
# g.close will do it implicitly.
g.shutdown()

# Note also that handles are automatically closed if they are
# reaped by reference counting.  You only need to call close
# if you want to close the handle right away.
g.close()
