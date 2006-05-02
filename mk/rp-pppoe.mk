# Makefile for rp-pppoe
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

PKG := rp-pppoe
SRC_FILENAME = rp-pppoe-3.5.tar.gz
EXTRACTED_DIR = rp-pppoe-3.5
DOWNLOAD_SITES = \
		http://www.roaringpenguin.com/penguin/pppoe/ \
		$(CFLINUX_PACKAGES)
PATCHES = rp-pppoe.patch \
	rp-pppoe.relay_c_nonblock_io.patch \
	rp-pppoe.configure.patch \
	rp-pppoe.wild_ifname.patch \
	rp-pppoe.relay.patch \
	rp-pppoe.dont_close_fds.patch \
	rp-pppoe.relay.c_padi_no_warn.patch \
	rp-pppoe.relay_h_maxinterfaces.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT)/src ; ./configure --enable-plugin=$(BUILD_DIR)/ppp)
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT)/src distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/src all $(UC_PATH) PLUGIN_DIR=/usr/lib/pppd
	touch $(BUILT_STAMP)

install: build
	for i in pppoe pppoe-server pppoe-sniff pppoe-relay ; do \
		$(INSTALL_BIN) $(PKG_ROOT)/src/$$i $(ROOTFS)/usr/sbin/ ; \
	done

.PHONY: configure clean build install
