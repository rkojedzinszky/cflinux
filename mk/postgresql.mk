# Makefile for postgresql
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

PKG := postgres
SRC_FILENAME = postgresql-base-7.3.5.tar.bz2
EXTRACTED_DIR = postgresql-7.3.5
DOWNLOAD_SITES = \
		ftp://ftp3.hu.postgresql.org/pub/postgresql/source/v7.3.5/ \
		ftp://ftp2.is.postgresql.org/pub/postgresql/source/v7.3.5/ \
		ftp://ftp3.us.postgresql.org/pub/postgresql/source/v7.3.5/ \
		ftp://ftp15.us.postgresql.org/source/v7.3.5/ \
		ftp://ftp.at.postgresql.org/db/www.postgresql.org/pub/source/v7.3.5/ \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); $(UC_PATH) ./configure \
	 --without-readline --disable-largefile --prefix=/usr \
	 --libdir=/lib --includedir=/include --disable-static)
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/src/bin/psql all $(UC_PATH)
	$(MAKE) -C $(PKG_ROOT)/src/interfaces/libpq all $(UC_PATH)
	$(MAKE) -C $(PKG_ROOT)/src/include install DESTDIR=$(UC_ROOT)
	$(MAKE) -C $(PKG_ROOT)/src/interfaces/libpq install-lib DESTDIR=$(UC_ROOT)
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT)/src/bin/psql install DESTDIR=$(ROOTFS)
	$(MAKE) -C $(PKG_ROOT)/src/interfaces/libpq install-lib-shared DESTDIR=$(ROOTFS)/usr

.PHONY: configure clean build install
