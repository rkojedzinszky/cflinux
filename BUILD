BUILD of compact flash linux project
------------------------------------

1.	Required packages tu build
	
The recommended (required) packages needed to build cflinux are:
- zlib-dev
- bison/yacc
- flex
- sharutils
- grub
- m4

Any other *-dev packages should be removed, especially
libpcap-dev and libssl-dev. They may confuse some scripts and
make them use wrong libraries.

2.	Extracting and compiling

You extract the source in the usual way:
	$ tar xzf cflinux-x.x.x.tar.gz
After it's done, cd to the dir, and issue 'make all'. If everything
goes right, at the end you will get no errors. Then you issue
'make install' and 'make image'. The latter needs ramdisk and minix
support on your running system, without them it won't work.

If it succeeds, you'll get a rootfs.bin at your cflinux's root.

3.	Installing

To make the CF work, please insert it at /dev/hdc, and make sure
no program uses it (eg smartsuite, or alikes), then issue
./part_init.sh. !!! IT DESTROYS THE CONTENTS OF /dev/hdc !!!
It will repartition /dev/hdc, and installs grub as its
bootloader. After it write the root image to the cf:
	$ cat rootfs.bin > /dev/hdc5

All right, we are done, now just boot the CF card. Please,
leave it at /dev/hdc, as it is the default place for it.
After it has booted, you get a login prompt, and you
can login into your fresh CF system as root/cfdef.
As the boot loader passes the default console to be the serial
device to the kernel, you may not see the kernel booting
on the display, so dont panic. Also, at first time, ssh keys
are generated, which again takes time, so just be patient.
But of course, you may edit grub's config to not redirect the
console. After you may want to edit network related stuff at
/etc/rc.network, and have a look at /usr/share/defaults/rc.conf.
This can be overridden by editing /etc/rc.conf. After making
changes to /etc, dont forget to issue 'savedata', as it will
write the current /etc to the CF.

4.	Notes

 - The root filesystem is a read-only cramfs filesystem,
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
 - if you want cflinux to boot from other device than
/dev/hdc, you must ensure you pass the 'root' parameter
to the kernel. Of course, this is not a big deal, but you
must do it. So, for example, if you plan to use it on /dev/hda,
just install it the usual way, and at the first boot time,
you should edit grub to pass root=/dev/hda5 to the kernel
(you should be familiar with grub). Then boot the kernel,
and once cflinux started, you must edit /etc/fstab to match
your needs (e.g. replacing /dev/hdc with /dev/hda everywhere).
And dont forget to edit /boot/grub/menu.lst also. If everything
is right, just restart the system, and it should boot up,
using /dev/hda as the system device. After it you dont have
to worry when upgrading the system.

Have fun with it!

Questions and criticism are welcome at cflinux@mail.cflinux.hu
list, but it is closed, so you must subscribe to it before sending
mails.

Richard Kojedzinszky <krichy@tvnetwork.hu>
2004. Sep. 17
http://www.cflinux.hu/

