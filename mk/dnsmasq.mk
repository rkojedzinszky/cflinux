# Makefile for dnsmasq
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

PKG := dnsmasq
PKG_VERSION = 2.63
SRC_FILENAME = dnsmasq-$(PKG_VERSION).tar.gz
EXTRACTED_DIR = dnsmasq-$(PKG_VERSION)
DOWNLOAD_SITES = http://www.thekelleys.org.uk/dnsmasq/ \
		$(CFLINUX_PACKAGES)

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
	$(MAKE) -C $(PKG_ROOT) all CC=$(TARGET_CC)
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/src/dnsmasq $(ROOTFS)/usr/sbin/
	$(INSTALL) -m 444 $(PKG_ROOT)/dnsmasq.conf.example \
			                $(DEFAULTS_DIR)/etc/dnsmasq.conf.example

.PHONY: configure clean build install
