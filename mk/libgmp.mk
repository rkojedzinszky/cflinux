# Makefile for gnu mp lib
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

PKG := gmp
SRC_FILENAME = gmp-4.2.1.tar.gz
EXTRACTED_DIR = gmp-4.2.1
DOWNLOAD_SITES = \
		ftp://ftp.sunet.se/pub/gnu/gmp/ \
		ftp://ftp.funet.fi/pub/gnu/prep/gmp/ \
		ftp://ftp.informatik.rwth-aachen.de/pub/gnu/gmp/ \
		ftp://ftp.nectec.or.th/pub/mirrors/gnu/gmp/gmp/ \
		ftp://ftp.gnu.org/gnu/gmp/ \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); $(UC_PATH) CC=gcc ./configure --prefix=/ \
	 --disable-static --enable-shared --with-pic --with-gnu-ld --host=i386-linux)
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH)
	$(MAKE) -C $(PKG_ROOT) install DESTDIR=$(UC_ROOT)
	touch $(BUILT_STAMP)

install: build check
	$(MAKE) -C $(PKG_ROOT) install-libLTLIBRARIES DESTDIR=$(ROOTFS)/usr
	strip -s $(ROOTFS)/usr/lib/libgmp.so

check:
	$(MAKE) -C $(PKG_ROOT) check $(UC_PATH)

.PHONY: configure clean build install
