# Makefile for base
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

# $Id$

PKG := base

# include the common package targets 
include $(TOP_DIR)/config.mk

INSTALL_STAMP = $(PKG_ROOT)/.$(PKG).installed
PKG_ROOT = $(FDEVEL_DIR)/cfbase

patch:

extract:

download:

configure:

clean:
	rm -rf $(ROOTFS)/*
	rm -f $(INSTALL_STAMP)

build:

install: $(INSTALL_STAMP)

$(INSTALL_STAMP):
	-mkdir $(ROOTFS)
	-chmod 755 $(ROOTFS)
	-chown 0:0 $(ROOTFS)
	for i in bin boot dev/net etc lib mnt proc sbin usr var \
		usr/bin usr/lib usr/sbin usr/local dev/pts \
		usr/lib/cfmaint usr/lib/cflinux ; do \
			mkdir -p $(ROOTFS)/$$i ; done
	mkdir -p $(DEFAULTS_DIR)/etc
	ln -s var/tmp $(ROOTFS)/tmp
	ln -s etc/root $(ROOTFS)/root
	(cd $(ROOTFS)/dev ; MAKEDEV std hda hdb hdc hdd \
		console ptmx rtc ttyS0 ttyS1 ttyS2 ttyS3 ppp sda sdb; \
		mknod watchdog c 10 130; \
		mknod net/tun c 10 200)
	$(INSTALL) -d -m 555 $(ROOTFS)/sbin/init.d
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/init.d/rcS \
		$(ROOTFS)/sbin/init.d/
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/shutdown \
		$(ROOTFS)/sbin/init.d/
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/linuxrc \
		$(ROOTFS)/linuxrc
	cp -v $(PKG_ROOT)/defaults/inittab \
		$(DEFAULTS_DIR)/etc/inittab
	cp -v $(PKG_ROOT)/scripts/common.sh $(ROOTFS)/usr/lib/cfmaint/
	cp -v $(PKG_ROOT)/defaults/modules \
		$(DEFAULTS_DIR)/etc/modules
	cp -v $(PKG_ROOT)/scripts/rc.conf.defaults \
		$(DEFAULTS_DIR)/etc/rc.conf
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/savedata $(ROOTFS)/sbin/
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/eraseconf.sh $(ROOTFS)/sbin/
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/reflash $(ROOTFS)/sbin/
	$(INSTALL) -d $(ROOTFS)/usr/share/udhcpc
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/udhcpc.events \
		$(ROOTFS)/usr/share/udhcpc/default.script
# installing cfpkg scripts
	$(INSTALL) -d -m 555 $(ROOTFS)/usr/lib/cfpkg
	$(INSTALL) -m 444 $(PKG_ROOT)/scripts/cfpkg/lib/cfpkg_common.sh \
		$(ROOTFS)/usr/lib/cfpkg/
	for i in cfpkg_add cfpkg_delete ; do \
		$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/cfpkg/sbin/$$i \
			$(ROOTFS)/usr/sbin/ ; done
	$(INSTALL) -m 444 -o 0 -g 0 $(PKG_ROOT)/scripts/hackps.sh \
		$(ROOTFS)/usr/lib/cflinux/
	touch $@

.PHONY: configure clean build install
