# Makefile for farsync
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

PKG := farsync
SRC_FILENAME = farsync.tar.bz2
EXTRACTED_DIR = farsync
DOWNLOAD_SITES = http://web.tvnetwork.hu/~krichy/cfdev/downloads/package_src/

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT)/common clean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/common farutil fartest $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	for i in farutil fartest ; do \
		$(INSTALL_BIN) $(PKG_ROOT)/common/$$i $(ROOTFS)/sbin/ ; \
	done
	-test -d $(ROOTFS)/usr/share/farsync && \
		rm -rf $(ROOTFS)/usr/share/farsync
	mkdir $(ROOTFS)/usr/share/farsync
	cp -R $(PKG_ROOT)/common/downloads $(ROOTFS)/usr/share/farsync/
	$(INSTALL_SCRIPT) $(PKG_ROOT)/common/farsync.init \
		$(ROOTFS)/usr/share/farsync/

.PHONY: configure clean build install
