# Makefile for quagga
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

PKG := quagga
SRC_FILENAME = quagga-0.98.6.tar.gz
EXTRACTED_DIR = quagga-0.98.6
DOWNLOAD_SITES = http://www.quagga.net/download/ \
		$(CFLINUX_PACKAGES)
PATCHES = quagga.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); $(UC_PATH) UC_ROOT=$(UC_ROOT) ./configure --prefix=/usr \
		--sysconfdir=/etc/zebra \
		--disable-ipv6 --enable-netlink --enable-nssa \
		--enable-ospf-te --enable-opaque-lsa \
		--disable-ospfapi \
		--enable-user=quagga --enable-group=quagga \
		--enable-multipath=64 \
		--localstatedir=/var/quagga )
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
	for i in $(PKG_ROOT)/lib/.libs/libzebra.so* ; do \
		$(INSTALL_BIN) $$i $(ROOTFS)/usr/lib/ ; done
	for i in zebra ospfd ripd bgpd ; do \
		$(MAKE) -C $(PKG_ROOT)/$$i install-sbinPROGRAMS \
		DESTDIR=$(ROOTFS) INSTALL_STRIP_FLAG=-s ; \
		strip -s $(ROOTFS)/usr/sbin/$$i ; done

.PHONY: configure clean build install
