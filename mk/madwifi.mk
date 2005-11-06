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
SRC_FILENAME = madwifi-svn-rev-1302.tar.bz2
EXTRACTED_DIR = madwifi
DOWNLOAD_SITES = \
		$(CFLINUX_PACKAGES)
PATCHES = madwifi.nodebug.patch \
	  madwifi.tools::Makefile.patch

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

# here the rate algorithm can be selected
# for current version, on of amrr, onoe, simple
A_RATE := amrr

# the required tools
TOOLS = athctrl athkey

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH) \
		KERNELPATH=$(BUILD_DIR)/kernel \
		KERNELRELEASE=$(KERNEL_VERSION) \
		ATH_RATE=ath_rate/$(A_RATE)
	$(MAKE) -C $(PKG_ROOT)/tools $(TOOLS) $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	cp $(PKG_ROOT)/net80211/wlan.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/ath_hal/ath_hal.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/ath/ath_pci.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/ath_rate/$(A_RATE)/ath_rate_$(A_RATE).o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	$(MAKE) -C $(PKG_ROOT)/tools install BINDIR=/sbin DESTDIR=$(ROOTFS) \
		ALL_INSTALL="$(TOOLS)"

.PHONY: configure clean build install
