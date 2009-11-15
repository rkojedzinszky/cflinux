# Makefile for ppp
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

PKG := ppp
SRC_FILENAME = ppp-cvs-20050725-p1.tar.bz2
EXTRACTED_DIR = ppp-cvs-20050725-p1
DOWNLOAD_SITES = \
	$(CFLINUX_PACKAGES)

PATCHES = ppp.patch \
	ppp.pathnames_h_connect_errors.patch \
	ppp.radius_untimeout.patch \
	ppp.periodic_stats.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ./configure --prefix=/usr
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) dist-clean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all CC=$(TARGET_CC)
	touch $(BUILT_STAMP)

install: build
	-mkdir $(ROOTFS)/usr/lib/pppd
	$(INSTALL_BIN) $(PKG_ROOT)/pppd/pppd $(ROOTFS)/usr/sbin
	$(INSTALL_BIN) $(PKG_ROOT)/pppd/plugins/radius/radius.so \
		$(ROOTFS)/usr/lib/pppd/
	$(INSTALL_BIN) $(PKG_ROOT)/pppd/plugins/radius/radattr.so \
		$(ROOTFS)/usr/lib/pppd/
	$(INSTALL_BIN) $(PKG_ROOT)/pppd/plugins/rp-pppoe/rp-pppoe.so \
		$(ROOTFS)/usr/lib/pppd/

.PHONY: configure clean build install
