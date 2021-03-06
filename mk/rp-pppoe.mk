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
SRC_FILENAME = rp-pppoe-3.11.tar.gz
EXTRACTED_DIR = rp-pppoe-3.11
DOWNLOAD_SITES = http://www.roaringpenguin.com/files/download \
		$(CFLINUX_PACKAGES)
PATCHES = \
	rp-pppoe.configure.patch \
	rp-pppoe.relay_c_nonblock_io.patch \
	rp-pppoe.relay_h_maxinterfaces.patch \
	rp-pppoe.plugin_type.patch \
	rp-pppoe.padt_nolog.patch


# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT)/src && \
		autoconf && \
		ac_cv_func_setvbuf_reversed=no \
		ac_cv_sizeof_unsigned_short=2 \
		ac_cv_sizeof_unsigned_int=4 \
		ac_cv_sizeof_unsigned_long=4 \
		rpppoe_cv_pack_bitfields=normal \
		./configure --host=$(TARGET_HOST) \
			--enable-plugin=$(BUILD_DIR)/ppp
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT)/src distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/src all PLUGIN_DIR=/usr/lib/pppd \
		PPPD_PATH=/usr/sbin/pppd
	touch $(BUILT_STAMP)

install: build
	for i in pppoe pppoe-server pppoe-sniff pppoe-relay ; do \
		$(INSTALL_BIN) $(PKG_ROOT)/src/$$i $(ROOTFS)/usr/sbin/ ; \
	done

.PHONY: configure clean build install
