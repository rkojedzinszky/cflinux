# Makefile for openswan
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

PKG := openswan
SRC_FILENAME = openswan-2.2.0.tar.gz
EXTRACTED_DIR = openswan-2.2.0
DOWNLOAD_SITES = http://www.openswan.org/download/ \
		$(CFLINUX_PACKAGES)
PATCHES = openswan.patch \
	  openswan.nodebug.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) programs $(UC_PATH) \
		KERNELSRC=$(BUILD_DIR)/kernel \
		INC_USRLOCAL=/usr
	touch $(BUILT_STAMP)

install: build
	rm -rf $(ROOTFS)/usr/lib/ipsec $(ROOTFS)/usr/sbin/ipsec \
		$(ROOTFS)/usr/libexec/ipsec
	$(MAKE) -C $(PKG_ROOT) install DESTDIR=$(ROOTFS) \
		INC_USRLOCAL=/usr
	for i in calcgoo verify ; do \
		rm -f $(ROOTFS)/usr/libexec/$$i ; done
	for i in eroute klipsdebug pf_key pluto _pluto_adns \
		ranbits rsasigkey \
		spi spigrp starter tncfg whack; do \
		strip -s $(ROOTFS)/usr/libexec/ipsec/$$i ; done
	for i in _copyright ; do \
		strip -s $(ROOTFS)/usr/lib/ipsec/$$i ; done

.PHONY: configure clean build install
