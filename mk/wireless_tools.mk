# Makefile for wireless_tools
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

PKG := wireless_tools
SRC_FILENAME = wireless_tools.29.tar.gz
EXTRACTED_DIR = wireless_tools.29
DOWNLOAD_SITES = http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/ \
		$(CFLINUX_PACKAGES)

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
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH) BUILD_SHARED=y \
		CC=$(TARGET_HOST)-gcc \
		KERNEL_SRC=$(BUILD_DIR)/kernel \
		DEPFLAGS=
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) install-dynamic install-bin PREFIX=$(ROOTFS)

.PHONY: configure clean build install
