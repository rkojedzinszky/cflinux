# Makefile for tcpdump
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

PKG := tcpdump
PKG_VERSION = 4.4.0
SRC_FILENAME = tcpdump-$(PKG_VERSION).tar.gz
EXTRACTED_DIR = tcpdump-$(PKG_VERSION)
DOWNLOAD_SITES = http://www.tcpdump.org/release/ \
		$(CFLINUX_PACKAGES)

PATCHES =

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && \
		ac_cv_linux_vers=2 \
		td_cv_buggygetaddrinfo=no \
		PCAP_CONFIG=/bin/true \
		LDFLAGS=-lpcap \
		./configure --host=$(TARGET_HOST) \
		--prefix=/usr \
		--enable-ipv6 \
		--with-crypto=$(UC_ROOT)/usr
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/tcpdump $(ROOTFS)/usr/sbin/

.PHONY: configure clean build install
