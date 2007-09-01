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
SRC_FILENAME = madwifi-0.9.3.1.tar.bz2
EXTRACTED_DIR = madwifi-0.9.3.1
DOWNLOAD_SITES = \
	http://mesh.dl.sourceforge.net/sourceforge/madwifi/ \
	http://superb-east.dl.sourceforge.net/sourceforge/madwifi/ \
	http://optusnet.dl.sourceforge.net/sourceforge/madwifi/ \
	$(CFLINUX_PACKAGES)
PATCHES = madwifi.nodebug.patch

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

# the required tools
TOOLS = athchans athctrl athkey wlanconfig

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all \
		KERNELPATH=$(BUILD_DIR)/kernel \
		KERNELRELEASE=$(KERNEL_VERSION) CROSS_COMPILE=$(TARGET_HOST)- \
		$(UC_PATH_CROSS)
	$(MAKE) -C $(PKG_ROOT)/tools $(TOOLS) $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	cp $(PKG_ROOT)/net80211/wlan.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/ath_hal/ath_hal.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/ath/ath_pci.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/net80211/wlan_scan_ap.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/net80211/wlan_scan_sta.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	cp $(PKG_ROOT)/net80211/wlan_wep.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia
	for rate in onoe sample amrr ; do cp $(PKG_ROOT)/ath_rate/$$rate/ath_rate_$$rate.o \
		$(ROOTFS)/lib/modules/$(KERNEL_VERSION)/pcmcia ; done
	$(MAKE) -C $(PKG_ROOT)/tools install BINDIR=/sbin DESTDIR=$(ROOTFS) \
		ALL_INSTALL="$(TOOLS)"

.PHONY: configure clean build install
