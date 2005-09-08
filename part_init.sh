#!/bin/sh

# partition script for compact flash linux project
#
# Copyright (C) 2004 Richard Kojedzinszky <krichy@tvnetwork.hu>
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# it partitions /dev/hdc, and assumes that the target system will be on
# /dev/hdc (eg the cf card is at secondary/master)

# $Id$

maindev="/dev/hdc"
backup="part.$$"

# determine whether grub is installed
for src in "/lib" "/usr/lib" ; do
	if test -f ${src}/grub/i386*/stage1 ; then
		grubsrc=`echo ${src}/grub/i386*`
		break
	fi
done
if [ -z "$grubsrc" ]; then
	echo "Could not find grub installed on your system"
	echo "Please install it, and after try again."
	exit 1
fi

size=`sfdisk -s "$maindev"`
minreq=14544
if [ "$size" -lt "$minreq" ]; then
	echo "Disk is too small!"
	exit;
fi

do_backup=0
while [ "$1" ]; do
	case "$1" in
		--backup)
			do_backup=1
			;;
	esac
	shift
done

if [ "$do_backup" -eq 1 ]; then
	echo -n "Saving last partition table to $backup"
	dd if="$maindev" of="$backup" bs=1k count=16 2>/dev/null
	echo " done"
fi
sfdisk -R "$maindev"

echo -en "This will destroy the partition table of $maindev.\nAre you sure (yes/no) [no] ? "
read answer
case $answer in
	[yY][eE][sS])
		;;
	*)
		echo "Aborting..."
		exit 1
		;;
esac

echo -n "Clearing partition table"
dd if=/dev/zero of="$maindev" bs=1k count=16 2>/dev/null
echo " done"

geometry=`sfdisk -g "$maindev" | sed -n 's/^.*: \([0-9]\+\) cylinders, \([0-9]\+\) heads, \([0-9]\+\) sectors.*$/cyl=\1 head=\2 track=\3/p'`
if [ $? -ne 0 ]; then
	echo "Error getting disk geometry."
	exit
fi
eval "$geometry"

cylsects=`expr $head \* $track`

div () # returns ceil($1/$2)
{
	expr \( $1 + $2 - 1 \) / $2
}

dcnt=`div 4096 $cylsects`
bcnt=`div 512 $cylsects`
rcnt=`div 20480 $cylsects`

cmdf=$(/bin/tempfile)
st=1
(
 echo "$st,$dcnt"
 st=$[st+$dcnt]
 echo "$st,$dcnt"
 st=$[st+$dcnt]
 echo "$st,$bcnt"
 st=$[st+$bcnt]
 size=$[cyl-$st]
 echo "$st,$size E"
 echo "$st,$rcnt"
 st=$[st+$rcnt]
 size=$[cyl-$st]
 echo "$st,$size"
) | sfdisk -uC "$maindev"

bootdev="${maindev}3"
mke2fs "${bootdev}"
mount "${bootdev}" /mnt
mkdir /mnt/grub
cd /mnt/grub
cp ${grubsrc}/stage1 .
cp ${grubsrc}/stage2 .
cp ${grubsrc}/e2fs_stage1_5 .
cat > menu.lst <<EOF
timeout 5

title cf
kernel (hd0,4)1+2048 root=${maindev}5 #console=ttyS0,115200
EOF
cat <<EOF | grub --batch
device (hd0) $maindev
root (hd0,2)
embed /grub/e2fs_stage1_5 (hd0)
install /grub/stage1 (hd0) (hd0)1+16 p (hd0,2)/grub/stage2 /grub/menu.lst
EOF
echo ""
cd /
umount /mnt
mke2fs "${maindev}6"
