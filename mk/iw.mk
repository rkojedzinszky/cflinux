# Makefile for iw
#
# Copyright (C) 2010 Richard Kojedzinszky <krichy@tvnetwork.hu>
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

PKG := iw
SRC_FILENAME = iw-3.11.tar.bz2
EXTRACTED_DIR = iw-3.11
DOWNLOAD_SITES = https://www.kernel.org/pub/software/network/iw/ \
		$(CFLINUX_PACKAGES)

PATCHES = iw.version.sh.patch \
	  iw.Makefile.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) realclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH) \
		CC=$(TARGET_HOST)-gcc \
		PKG_CONFIG=/bin/true \
		EXTRA_INCLUDES=-I$(UC_ROOT)/usr/include/libnl3
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/iw $(ROOTFS)/sbin/


.PHONY: configure clean build install
