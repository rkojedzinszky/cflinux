# Makefile for libnl
#
# Copyright (C) 2010 Richard Kojedzinszky <krichy@tvnetwork.hu>
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

PKG := libnl
SRC_FILENAME = libnl-d378220c96c3c8b6f27dca33e7d8ba03318f9c2d.tar.bz2
EXTRACTED_DIR = libnl-d378220c96c3c8b6f27dca33e7d8ba03318f9c2d
DOWNLOAD_SITES = $(CFLINUX_PACKAGES)

# include the common package targets
include $(TOP_DIR)/packages.mk

configure: patch $(CONFIGURED_STAMP)

$(PKG_ROOT)/configure:
	cd $(PKG_ROOT) && sh autogen.sh

$(CONFIGURED_STAMP): $(PKG_ROOT)/configure
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
		--with-gnu-ld \
		--prefix=/usr
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/lib install $(UC_PATH) DESTDIR=$(UC_ROOT)
	$(MAKE) -C $(PKG_ROOT)/include install $(UC_PATH) DESTDIR=$(UC_ROOT)
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT)/lib install $(UC_PATH) DESTDIR=$(ROOTFS)

.PHONY: configure clean build install

