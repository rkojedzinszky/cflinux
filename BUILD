BUILD of compact flash linux project
------------------------------------

I built it on a stable debian woody system. I recommend you to
remove all devel packages (*-dev in debian), to make sure the
packages in cflinux uses the right libs. Some package may need
flex and bison. Also grub is needed to make the CF bootable.

Uncompress the contents of the tar to a directory:
	$ tar xzf cflinux-0.1.tar.gz

After it's done, cd to the dir, and issue 'make all'. If everything
goes the right way, at the end you will get no errors.
Then you issue 'make install' and 'make image'. The latter needs
ramdisk and minix support on your running system, without them
it won't work.

If it succeeds, you'll get a rootfs.bin at your cflinux's root.

To make the CF work, please insert it at /dev/hdc, and make sure
no program uses it (eg smartsuite, or alikes), then issue
./part_init.sh. !!! IT DESTROYS THE CONTENTS OF /dev/hdc !!!
It will repartition /dev/hdc, and installs grub as its
bootloader. After it write the root image to the cf:
	$ cat rootfs.bin > /dev/hdc5

All right, we are done, now just boot the CF card. Please,
leave it at /dev/hdc, as it is the default place for it.
After it has booted, you get a login prompt, and you
can login into your fresh CF system as root/cfdef. Edit
network related stuff at /etc/rc.network, and have a look
at /usr/share/defaults/rc.conf. This can be overridden by
editing /etc/rc.conf. After making changes, dont forget to
issue 'savedata', as it will write the current /etc to the
CF.

Have fun with it!

Richard Kojedzinszky <krichy@tvnetwork.hu>
2004. Jan. 25.
