# Makefile for busybox
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

PKG := busybox
SRC_FILENAME = busybox-1.4.2.tar.bz2
EXTRACTED_DIR = busybox-1.4.2
DOWNLOAD_SITES = http://busybox.net/downloads/ \
		$(CFLINUX_PACKAGES)

PATCHES = busybox.init.patch \
	busybox.crond.patch \
	busybox.rdate.patch \
	busybox.ifenslave.patch \
	busybox.httpd_c.patch \
	busybox.wget_c.patch \
	busybox.no_halt_poweroff.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cp $(CONFIGS)/$(PKG).config $(PKG_ROOT)/.config
	$(MAKE) -C $(PKG_ROOT) oldconfig
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	find $(ROOTFS) -lname '*busybox' -print0 | xargs -0 rm -f
	-mkdir -p $(ROOTFS)/usr/share/udhcpc
	$(MAKE) -C $(PKG_ROOT) install CONFIG_PREFIX=$(ROOTFS)

.PHONY: configure clean build install
