# Makefile for openssl
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

PKG := openssl
SRC_FILENAME = openssl-0.9.6m.tar.gz
EXTRACTED_DIR = openssl-0.9.6m
DOWNLOAD_SITES = http://www.openssl.org/source/

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); ./Configure linux-elf)
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) clean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all build-shared $(UC_PATH)
	cp -a $(PKG_ROOT)/libcrypto.so* $(UC_ROOT)/lib
	cp -a $(PKG_ROOT)/libssl.so* $(UC_ROOT)/lib
	cp -vLr $(PKG_ROOT)/include/openssl $(UC_ROOT)/include
	touch $(BUILT_STAMP)

install: build
	for i in $(PKG_ROOT)/libcrypto.so* $(PKG_ROOT)/libssl.so* ; do \
		$(INSTALL_BIN) $$i $(ROOTFS)/usr/lib/ ; done

.PHONY: configure clean build install
