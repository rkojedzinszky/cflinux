# Makefile for madwifi
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

PKG := madwifi
SRC_FILENAME = madwifi-20030802.tgz
EXTRACTED_DIR = madwifi-20030802
DOWNLOAD_SITES = \
		http://heanet.dl.sourceforge.net/sourceforge/madwifi/ \
		http://easynews.dl.sourceforge.net/sourceforge/madwifi/ \
		http://aleron.dl.sourceforge.net/sourceforge/madwifi/ \
		http://cesnet.dl.sourceforge.net/sourceforge/madwifi/

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
		KERNEL_PATH=$(BUILD_DIR)/kernel \
		KERNEL_VERSION=$(KERNEL_VERSION)
	touch $(BUILT_STAMP)

install: build
	cp $(PKG_ROOT)/wlan/wlan.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/ath_hal/ath_hal.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/driver/ath_pci.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia

.PHONY: configure clean build install
