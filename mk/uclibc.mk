# Makefile for uclibc
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

PKG := uclibc
SRC_FILENAME = uClibc-0.9.26.tar.bz2
EXTRACTED_DIR = uClibc-0.9.26
DOWNLOAD_SITES = http://www.uclibc.org/downloads/ \
		$(CFLINUX_PACKAGES)
PATCHES = uClibc-0.9.26.patch \
	  uClibc.resolv_c.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cp $(CONFIGS)/$(PKG).config $(PKG_ROOT)/.config
	$(MAKE) -C $(PKG_ROOT) oldconfig
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f /lib/ld-uClibc*
	rm -rf $(FDEVEL_DIR)/i386-linux-uclibc
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all BUILD_DIR=$(BUILD_DIR)
	$(MAKE) -C $(PKG_ROOT) install
	cp -a $(PKG_ROOT)/lib/ld-uC* /lib/
	$(MAKE) -C $(PKG_ROOT)/utils ldd $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	cp -av $(PKG_ROOT)/lib/*.so* $(ROOTFS)/lib/
	$(INSTALL_BIN) $(PKG_ROOT)/utils/ldd $(ROOTFS)/usr/bin/

.PHONY: configure clean build install
