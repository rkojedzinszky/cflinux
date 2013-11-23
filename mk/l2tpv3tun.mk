# Makefile for l2tpv3tun
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

PKG := l2tpv3tun
PKG_VERSION = 0.2
SRC_FILENAME = l2tpv3tun-$(PKG_VERSION).tar.gz
EXTRACTED_DIR = l2tpv3tun-$(PKG_VERSION)
DOWNLOAD_SITES = ftp://ftp.openl2tp.org/releases/ \
		$(CFLINUX_PACKAGES)

PATCHES = l2tpv3tun.compile.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) clean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all CC=$(TARGET_CC) EXTRA_INCLUDES=-I$(UC_ROOT)/usr/include/libnl3
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) install DESTDIR=$(ROOTFS)

.PHONY: configure clean build install
