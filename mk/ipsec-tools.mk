# Makefile for ipsec-tools
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

PKG := ipsec-tools
SRC_FILENAME = ipsec-tools-0.8.1.tar.bz2
EXTRACTED_DIR = ipsec-tools-0.8.1
DOWNLOAD_SITES = \
		http://netcologne.dl.sourceforge.net/project/ipsec-tools/ipsec-tools/0.8.0 \
		http://ignum.dl.sourceforge.net/project/ipsec-tools/ipsec-tools/0.8.0 \
		$(CFLINUX_PACKAGES)
PATCHES = \
	ipsec-tools.0001-Fix-handling-of-deletion-notification.patch \
	ipsec-tools.0002-From-Ian-West-ian-niw.com.au-Fix-double-free-of-the-.patch \
	ipsec-tools.0003-Fix-source-port-selection.patch \
	ipsec-tools.0004-Some-logging-improvements.patch \
	ipsec-tools.0005-From-Rainer-Weikusat-rweikusat-mobileactivedefense.c.patch \
	ipsec-tools.0006-From-Rainer-Weikusat-rweikusat-mobileactivedefense.c.patch \
	ipsec-tools.0007-From-Alexander-Sbitnev-alexander.sbitnev-gmail.com-f.patch \
	ipsec-tools.0008-From-Paul-Barker-Remove-redundant-memset-after-callo.patch \
	ipsec-tools.0009-From-Sven-Vermeulen-sven.vermeulen-siphos.be-Moves-p.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
			--with-kernel-headers=$(UC_ROOT)/usr/include/ \
			--prefix=/usr \
			--sysconfdir=/etc/racoon \
			--enable-shared \
			--enable-frag \
			--enable-natt \
			--enable-dpd \
			--enable-ipv6 \
			--with-readline=no \
			--enable-security-context=no \
			CFLAGS=-Wno-strict-aliasing

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
	$(MAKE) -C $(PKG_ROOT) install-exec DESTDIR=$(ROOTFS)

.PHONY: configure clean build install

