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

PKG := base
SRC_FILENAME = base.tar.bz2
EXTRACTED_DIR = base
DOWNLOAD_SITES = http://web.tvnetwork.hu/~krichy/cfdev/downloads/package_src/

# include the common package targets 
include $(TOP_DIR)/packages.mk 

INSTALL_STAMP = $(PKG_ROOT)/.$(PKG).installed

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	touch $(CONFIGURED_STAMP)

clean:
	rm -rf $(ROOTFS)/*
	rm -f $(INSTALL_STAMP)
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	touch $(BUILT_STAMP)

install: build $(INSTALL_STAMP)

$(INSTALL_STAMP):
	for i in bin boot dev etc lib mnt proc sbin usr var \
		usr/bin usr/lib usr/sbin usr/local dev/pts \
		usr/lib/cfmaint usr/share/defaults ; do \
			mkdir -p $(ROOTFS)/$$i ; done
	ln -s var/tmp $(ROOTFS)/tmp
	ln -s etc/root $(ROOTFS)/root
	(cd $(ROOTFS)/dev ; MAKEDEV std hda hdb hdc hdd \
		console ptmx rtc ttyS0 ttyS1 ttyS2 ttyS3 ppp)
	cp -av $(PKG_ROOT)/scripts/init.d $(ROOTFS)/sbin/
	cp -v $(PKG_ROOT)/defaults/inittab $(ROOTFS)/etc/inittab
	cp -v $(PKG_ROOT)/scripts/common.sh $(ROOTFS)/usr/lib/cfmaint/
	cp -v $(PKG_ROOT)/defaults/modules \
		$(ROOTFS)/usr/share/defaults/modules
	cp -v $(PKG_ROOT)/scripts/rc.conf.defaults \
		$(ROOTFS)/usr/share/defaults/rc.conf
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/savedata $(ROOTFS)/sbin/
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/reflash $(ROOTFS)/sbin/
	$(INSTALL) -d $(ROOTFS)/usr/share/udhcpc
	$(INSTALL_SCRIPT) $(PKG_ROOT)/scripts/udhcpc.events \
		$(ROOTFS)/usr/share/udhcpc/default.script
	touch $@

.PHONY: configure clean build install
