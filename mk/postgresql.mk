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
POSTGRES_VER = 9.3.1
SRC_FILENAME = postgresql-$(POSTGRES_VER).tar.bz2
EXTRACTED_DIR = postgresql-$(POSTGRES_VER)
DOWNLOAD_SITES = \
		http://ftp.postgresql.org/pub/source/v$(POSTGRES_VER) \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ZIC=/usr/sbin/zic ./configure --host=$(TARGET_HOST) \
	 --without-readline --disable-largefile --prefix=/usr \
	 --libdir=/lib --includedir=/include --disable-static \
	 --with-system-tzdata=""
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT)/src/bin/psql all
	$(MAKE) -C $(PKG_ROOT)/src/bin/pg_config all
	$(MAKE) -C $(PKG_ROOT)/src/interfaces/libpq all
	$(MAKE) -C $(PKG_ROOT)/src/backend/utils fmgroids.h
	-$(MAKE) -C $(PKG_ROOT)/src/include install DESTDIR=$(UC_ROOT)/usr
	$(MAKE) -C $(PKG_ROOT)/src/interfaces/libpq install DESTDIR=$(UC_ROOT)/usr
	$(MAKE) -C $(PKG_ROOT)/src/bin/pg_config install DESTDIR=$(UC_ROOT)/usr bindir=/bin
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT)/src/bin/psql install DESTDIR=$(ROOTFS)
	$(MAKE) -C $(PKG_ROOT)/src/interfaces/libpq install-lib-shared DESTDIR=$(ROOTFS)/usr

.PHONY: configure clean build install
