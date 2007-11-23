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

export TOP_DIR := $(shell pwd)

DO_MK = base
DO_MK += kernel
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
DO_MK += net-tools
DO_MK += net-snmp
DO_MK += quagga
DO_MK += iputils
DO_MK += ppp
DO_MK += rp-pppoe
DO_MK += rp-l2tp
DO_MK += fwdg
DO_MK += postgresql
DO_MK += libgmp
DO_MK += mcom
DO_MK += poptop
DO_MK += vtun
DO_MK += ltraf
DO_MK += libnet
DO_MK += nemesis
DO_MK += ethtool
DO_MK += e2fsprogs
DO_MK += tools

include $(TOP_DIR)/config.mk

# Finish target is last
DO_MK += finish

all: build

download patch check build:
	for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk $@ || exit 1 ; done

clean:
	-for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk clean ; done
	rm -f rootfs*.bin

distclean: clean
	rm -rf $(BUILD_DIR)

scratch: distclean
	rm -rf $(SOURCES_DIR)
	rm -rf $(ROOTFS)

install: all
	for i in $(DO_MK) ; do $(MAKE) -f $(MK)/$$i.mk install || exit ; done

image:
	if [ "$$(id -u)" -ne 0 ] ; then echo "You must be root or use fakeroot." ; exit 1 ; fi
	cat bzpadder $(BUILD_DIR)/kernel/arch/i386/boot/bzImage > topad
	-mkdir $(FDEVEL_DIR)/fs_config/root
	-mkdir $(FDEVEL_DIR)/fs_config/rc.d
	cd $(FDEVEL_DIR)/fs_config && tar cf $(ROOTFS)/usr/share/defaults/etc.tar *
	rmdir $(FDEVEL_DIR)/fs_config/rc.d
	rmdir $(FDEVEL_DIR)/fs_config/root
	$(MKCRAMFS) -R -i topad $(ROOTFS) rootfs.bin
	$(MAKE) -C cfbase/scripts/upgrade setup.tgz
	$(PACKROOT) '$(VERSION_MAJOR)' '$(VERSION_MINOR)' '$(VERSION_PATCH)' '$(VERSION_EXTRA)' rootfs.bin cfbase/scripts/upgrade/setup.tgz cflinux-$(RELEASE_STRING).img
	rm -f topad

.PHONY: all build distclean clean install image scratch
