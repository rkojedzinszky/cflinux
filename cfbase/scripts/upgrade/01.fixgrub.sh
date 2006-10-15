#!/bin/sh

## this script is for upgrading the grub's meun.lst to
## load a kernel with size greater than 1MB
set -e

if grep -q "^kernel.*)1+4096" /boot/grub/menu.lst ; then
	exit 0
fi

echo "It seems that your grub menu entry has not been upgraded"
echo "to be able to load a kernel with size greater than 1MB."
echo "I can now alter your menu.lst to fit this needs, but you have"
echo "to confirm it."

tmp="grub.menu.lst.$$"

sed 's/^\(kernel.*)1+\)[0-9]\+/\14096/' /boot/grub/menu.lst > $tmp
echo -e "\n--- NEW GRUB MENU.LST ---"
cat $tmp
echo -e "--- MENU.LST ends ---"
echo -n "Do you let me to replace your menu.lst with the shown one? [N/y]"

read ans
case "$ans" in
	[yY]*)
		echo -n "Replacing you menu.lst "
		mount -o remount,rw /boot
		mv $tmp /boot/grub/menu.lst
		mount -o remount,ro /boot
		echo "done"
		exit 0
		;;
	*)
		rm -f "$tmp"
		echo "Not replacing your menu.lst. You should edit it by hand to"
		echo "load 4096 sectors of the kernel."
		exit 1
		;;
esac
