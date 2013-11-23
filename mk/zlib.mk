# Makefile for zlib
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

PKG := zlib
SRC_FILENAME = zlib-1.2.8.tar.gz
EXTRACTED_DIR = zlib-1.2.8
DOWNLOAD_SITES = \
		http://www.zlib.net/ \
		$(CFLINUX_PACKAGES)

# include the common package targets
include $(TOP_DIR)/packages.mk

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && CC=$(TARGET_CC) ./configure --shared
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all CC=$(TARGET_CC)
	cp -a $(PKG_ROOT)/libz.so* $(UC_ROOT)/usr/lib/
	cp -a $(PKG_ROOT)/zlib.h $(PKG_ROOT)/zconf.h $(PKG_ROOT)/zutil.h \
		$(UC_ROOT)/usr/include/
	touch $(BUILT_STAMP)

install: build
	for i in $(PKG_ROOT)/libz.so* ; do \
		$(INSTALL_BIN) $$i $(ROOTFS)/usr/lib ; done

.PHONY: configure clean build install
