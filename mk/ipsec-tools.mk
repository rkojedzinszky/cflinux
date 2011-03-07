# Makefile for ipsec-tools
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

PKG := ipsec-tools
SRC_FILENAME = ipsec-tools-0.8-alpha20090422.tar.bz2
EXTRACTED_DIR = ipsec-tools-0.8-alpha20090422
DOWNLOAD_SITES = \
		http://softlayer.dl.sourceforge.net/project/ipsec-tools/snapshots/0.8-alpha20090422/ \
		http://heanet.dl.sourceforge.net/project/ipsec-tools/snapshots/0.8-alpha20090422 \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
			--with-kernel-headers=$(UC_ROOT)/usr/include/ \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--enable-frag \
			--enable-natt \
			--enable-dpd \
			--with-readline=no \
			--enable-security-context=no \
			CFLAGS=-Wno-strict-aliasing

	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) install-exec DESTDIR=$(ROOTFS)

.PHONY: configure clean build install

