# Makefile for nemesis
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

PKG := nemesis
SRC_FILENAME = nemesis-1.4beta3.tar.gz
EXTRACTED_DIR = nemesis-1.4beta3
DOWNLOAD_SITES = http://www.packetfactory.net/projects/nemesis/ \
		$(CFLINUX_PACKAGES)
PATCHES = nemesis.include.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cp -f $(TOP_DIR)/cfbase/config.sub $(PKG_ROOT)/
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) --prefix=/usr \
	--with-libnet-includes=$(UC_ROOT)/usr/include \
	--with-libnet-libraries=$(UC_ROOT)/usr/lib
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
	$(MAKE) -C $(PKG_ROOT)/src install-exec-am DESTDIR=$(ROOTFS) \
		AM_INSTALL_PROGRAM_FLAGS=-s

.PHONY: configure clean build install

