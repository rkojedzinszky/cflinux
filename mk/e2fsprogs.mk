# Makefile for e2fsprogs
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

PKG := e2fsprogs
SRC_FILENAME = e2fsprogs-1.40.2.tar.gz
EXTRACTED_DIR = e2fsprogs-1.40.2
DOWNLOAD_SITES = \
		http://heanet.dl.sourceforge.net/sourceforge/e2fsprogs/ \
		http://keihanna.dl.sourceforge.net/sourceforge/e2fsprogs/ \
		http://flow.dl.sourceforge.net/sourceforge/e2fsprogs/ \
		http://aleron.dl.sourceforge.net/sourceforge/e2fsprogs/ \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
	 --with-cc=$(TARGET_CC) --with-linker=$(TARGET_LD) \
	 --disable-imager \
	 --enable-dynamic-e2fsck --disable-nls \
	 --without-libintl-prefix --disable-evms --enable-elf-shlibs
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
	$(MAKE) -C $(PKG_ROOT) install-strip DESTDIR=$(ROOTFS)

.PHONY: configure clean build install
