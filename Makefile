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

RELEASE = 0.1.1

ifndef DO_MK
DO_MK = base
DO_MK += kernel
DO_MK += uclibc
DO_MK += busybox
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
DO_MK += quagga
DO_MK += iputils
DO_MK += pcmcia-cs
DO_MK += hostap
DO_MK += hostapd
DO_MK += ppp
DO_MK += rp-pppoe
DO_MK += net-snmp
DO_MK += e2fsprogs
DO_MK += wireless_tools
DO_MK += madwifi

# Finish target is last
DO_MK += finish
endif

export TOP_DIR := $(shell pwd)
include config.mk

all:
	test -d $(BUILD_DIR) || mkdir $(BUILD_DIR)
	for i in $(DO_MK) ; do \
		make -f $(MK)/$$i.mk build || exit ; done

download:
	test -d $(SOURCES_DIR) || mkdir $(SOURCES_DIR)
	for i in $(DO_MK) ; do make -f $(MK)/$$i.mk download || exit 1 ; done

patch:
	for i in $(DO_MK) ; do make -f $(MK)/$$i.mk patch || exit 1 ; done

clean:
	for i in $(DO_MK) ; do make -f $(MK)/$$i.mk clean ; done
	rm -f rootfs.bin

distclean: clean
	rm -rf $(BUILD_DIR)

scratch: distclean
	rm -rf $(SOURCES_DIR)

install: all
	for i in $(DO_MK) ; do make -f $(MK)/$$i.mk install || exit ; done

image:
	cat bzpadder $(BUILD_DIR)/kernel/arch/i386/boot/bzImage > topad
	dd if=/dev/zero of=/dev/ram0 bs=1k count=2k
	mkfs.minix -v /dev/ram0 2047 >/dev/null 2>&1
	mount -t minix /dev/ram0 /mnt
	cp -a $(FDEVEL_DIR)/fs_config/* /mnt
	umount /mnt
	dd if=/dev/ram0 bs=1k of=$(ROOTFS)/usr/share/defaults/etc.img \
		count=2047 >/dev/null 2>&1
	mkcramfs -i topad $(ROOTFS) rootfs.bin
	rm -f topad

.PHONY: all distclean clean install image
