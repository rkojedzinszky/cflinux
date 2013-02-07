# Makefile for skeleton
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

# $Id$

PKG := hostapd
SRC_FILENAME = hostapd-2.0.tar.gz
EXTRACTED_DIR = hostapd-2.0
DOWNLOAD_SITES = http://hostap.epitest.fi/releases/ \
		$(CFLINUX_PACKAGES)
PATCHES =

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	perl -ne 's/^#(?=(CONFIG_(RADIUS_SERVER|IEEE80211W|DRIVER_NL80211)))//;' \
		-e 'print;' $(PKG_ROOT)/hostapd/defconfig > $(PKG_ROOT)/hostapd/.config
	echo "CONFIG_LIBNL20=y" >> $(PKG_ROOT)/hostapd/.config
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT)/hostapd distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/hostapd all $(UC_PATH) CC=$(TARGET_HOST)-gcc
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/hostapd/hostapd $(ROOTFS)/usr/sbin/
	$(INSTALL) -m 444 $(PKG_ROOT)/hostapd/hostapd.conf \
		$(DEFAULTS_DIR)/etc/

.PHONY: configure clean build install
