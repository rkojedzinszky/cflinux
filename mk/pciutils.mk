# Makefile for pciutils
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

PKG := pciutils
SRC_FILENAME = pciutils-3.1.7.tar.gz
EXTRACTED_DIR = pciutils-3.1.7
DOWNLOAD_SITES = ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/ \
		$(CFLINUX_PACKAGES)

PATCHES =
# pciutils.so.patch

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
	$(MAKE) -C $(PKG_ROOT) all CC=$(TARGET_CC) PREFIX=/usr
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/lspci $(ROOTFS)/usr/sbin/
	$(INSTALL_BIN) $(PKG_ROOT)/setpci $(ROOTFS)/usr/sbin/
	$(INSTALL) $(PKG_ROOT)/pci.ids.gz $(ROOTFS)/usr/share

.PHONY: configure clean build install
