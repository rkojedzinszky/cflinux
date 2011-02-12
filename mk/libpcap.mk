# Makefile for libpcap
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

PKG := libpcap
PKG_VERSION = 1.0.0
SRC_FILENAME = libpcap-$(PKG_VERSION).tar.gz
EXTRACTED_DIR = libpcap-$(PKG_VERSION)
DOWNLOAD_SITES = http://www.tcpdump.org/release/ \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
	 	--prefix=/usr \
		--with-pcap=linux \
		ac_cv_linux_vers=2
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(PKG_VERSION) $(UC_ROOT)/usr/lib/$(PKG).so
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) shared
	$(MAKE) -C $(PKG_ROOT) install-shared DESTDIR=$(UC_ROOT)
	ln -fs $(PKG).so.$(PKG_VERSION) $(UC_ROOT)/usr/lib/$(PKG).so
	$(INSTALL) -d $(UC_ROOT)/usr/include/pcap
	$(INSTALL) $(PKG_ROOT)/pcap/*.h $(UC_ROOT)/usr/include/pcap/
	for f in pcap.h pcap-bpf.h pcap-namedb.h ; do \
		$(INSTALL) $(PKG_ROOT)/$$f $(UC_ROOT)/usr/include/ ; \
	done
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) install-shared DESTDIR=$(ROOTFS)
	ln -fs $(PKG).so.$(PKG_VERSION) $(ROOTFS)/usr/lib/$(PKG).so.1

.PHONY: configure clean build install
