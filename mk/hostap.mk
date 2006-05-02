# Makefile for hostap
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

PKG := hostap
SRC_FILENAME = hostap-driver-0.4.7.tar.gz
EXTRACTED_DIR = hostap-driver-0.4.7
DOWNLOAD_SITES = http://hostap.epitest.fi/releases/ \
		$(CFLINUX_PACKAGES)
PATCHES = hostap.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) clean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH) \
		KERNEL_PATH=$(BUILD_DIR)/kernel
	touch $(BUILT_STAMP)

install: build
	cp $(PKG_ROOT)/driver/modules/*.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/driver/etc/hostap_cs.conf \
		$(FDEVEL_DIR)/fs_config/pcmcia/

.PHONY: configure clean build install
