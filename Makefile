#
# Makefile for compact flash linux project
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
#
# $Id$

ifndef DO_MK
DO_MK = base
DO_MK += grsec
DO_MK += kernel
DO_MK += tools
DO_MK += uclibc
DO_MK += db
DO_MK += busybox
DO_MK += mawk
DO_MK += farsync
DO_MK += zlib
DO_MK += openssl
DO_MK += openssh
DO_MK += iproute
DO_MK += iptables
DO_MK += libpcap
DO_MK += tcpdump
DO_MK += extra
DO_MK += net-tools
DO_MK += net-snmp
DO_MK += quagga
DO_MK += iputils
DO_MK += pcmcia-cs
DO_MK += hostap
DO_MK += hostapd
DO_MK += ppp
DO_MK += rp-pppoe
DO_MK += rp-l2tp
DO_MK += e2fsprogs
DO_MK += wireless_tools
DO_MK += madwifi
DO_MK += fwdg
DO_MK += bridge
DO_MK += postgresql
DO_MK += libgmp
DO_MK += openswan
DO_MK += mcom
DO_MK += poptop
DO_MK += vtun
DO_MK += ltraf
DO_MK += libnet
DO_MK += nemesis
DO_MK += ethtool

# Finish target is last
DO_MK += finish
endif

DISTFILES = AUTHOR BUILD LICENSE ChangeLog Makefile README UPGRADE bzpadder cfbase \
	    config.mk configs fs_config install_bin.sh md5sums mk \
	    packages.mk part_init.sh patches tools

export TOP_DIR := $(shell pwd)
include $(TOP_DIR)/config.mk

ifeq (local.mk,$(wildcard local.mk))
include local.mk
endif

all:
	for i in $(DO_MK) ; do \
		$(MAKE) -f $(MK)/$$i.mk build || exit ; done

download:
	for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk download || exit 1 ; done

patch:
	for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk patch || exit 1 ; done

clean:
	for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk clean ; done
	rm -f rootfs*.bin

distclean: clean
	rm -rf $(BUILD_DIR)

scratch: distclean
	rm -rf $(SOURCES_DIR)
	rm -rf $(ROOTFS)

install: all
	for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk install || exit ; done
	echo "$(RELEASE_STRING) ($(shell date "+%Y/%m/%d-%H.%M.%S"))" > $(ROOTFS)/.release

image:
	cat bzpadder $(BUILD_DIR)/kernel/arch/i386/boot/bzImage > topad
	dd if=/dev/zero of=/dev/ram0 bs=1k count=2k
	mkfs.minix -v /dev/ram0 2047 >/dev/null 2>&1
	mount -t minix /dev/ram0 /mnt
	cp -a $(FDEVEL_DIR)/fs_config/* /mnt
	find /mnt -type d -name CVS -print0 | xargs -0 rm -rf
	-mkdir /mnt/root /mnt/rc.d
	umount /mnt
	dd if=/dev/ram0 bs=1k of=$(ROOTFS)/usr/share/defaults/etc.img \
		count=2047 >/dev/null 2>&1
	$(MKCRAMFS) -i topad $(ROOTFS) rootfs-$(RELEASE_STRING).bin
	rm -f topad

dist: scratch
	rm -rf $(PACKAGE)-$(RELEASE_STRING)
	mkdir $(PACKAGE)-$(RELEASE_STRING)
	cp -R $(DISTFILES) $(PACKAGE)-$(RELEASE_STRING)
	find $(PACKAGE)-$(RELEASE_STRING) -type d -name CVS -print0 | xargs -0 rm -rf
	tar czf $(PACKAGE)-$(RELEASE_STRING).tar.gz $(PACKAGE)-$(RELEASE_STRING)
	rm -rf $(PACKAGE)-$(RELEASE_STRING)

.PHONY: all distclean clean install image scratch
