BUILD of compact flash linux project
------------------------------------

I built it on a stable debian woody system. I recommend you to
remove all devel packages (*-dev in debian), to make sure the
packages in cflinux uses the right libs. Some package may need
flex and bison. Also grub is needed to make the CF bootable.
For the madwifi package sharutils must be installed.

Uncompress the contents of the tar to a directory:
	$ tar xzf cflinux-x.x.x.tar.gz

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

Notes:
 - the root filesystem is a read-only cramfs filesystem,
so no modifications can be made on it.
 - All the configuration files reside on /etc, and that
data is written redundantly to the cf with each
'savedata' command. If by accident during a 'savedata' 
your system crashes, the old config still remains for you.
 - the unused space left on your cf can be accessed at
/dev/hdc6. First you'll have to mke2fs it (i suggest),
and comment out the last line in /etc/fstab. After done
it will be available on /usr/local. I suggest you to
store other binaries there as well as any content, but
it should be also in read-only state at all to prevent
loss of data.

Have fun with it!

Richard Kojedzinszky <krichy@tvnetwork.hu>
2004. Feb. 06.
