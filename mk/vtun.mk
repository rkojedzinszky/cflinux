# Makefile for vtun
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

PKG := vtun
SRC_FILENAME = vtun-3.0.1.tar.gz
EXTRACTED_DIR = vtun-3.0.1
DOWNLOAD_SITES = \
		http://downloads.sourceforge.net/vtun \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cp $(TOP_DIR)/toolchain/esrc/binutils-*/config.sub \
		$(TOP_DIR)/toolchain/esrc/binutils-*/config.guess \
		$(PKG_ROOT)/
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
	--prefix=/usr \
	--sysconfdir=/etc --disable-lzo \
	--with-ssl-headers=../openssl/include/openssl \
	--with-blowfish-headers=../openssl/include/openssl \
	--with-ssl-lib=../openssl --localstatedir=/var
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/vtund $(ROOTFS)/usr/sbin/
	$(INSTALL) -m 444 $(PKG_ROOT)/vtund.conf $(DEFAULTS_DIR)/etc/

.PHONY: configure clean build install
