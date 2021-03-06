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

PKG := skeleton
PKG_VERSION = 1
SRC_FILENAME = $(PKG)-$(PKG_VERSION).tar.gz
EXTRACTED_DIR = $(PKG)-$(PKG_VERSION)
DOWNLOAD_SITES = http://www.skel.eton.org/download/	# look at \
							# the ending \
							# dash
PATCHES = skel.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cp $(CONFIGS)/$(PKG).config $(PKG_ROOT)/.config
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
#	Install binary executable (strips the file)
#	$(INSTALL_BIN) $(PKG_ROOT)/skeleton $(ROOTFS)/usr/sbin/

#	Install Default configuration file
#	$(INSTALL) -o 0 -g 0 -m 444 $(PKG_ROOT)/skeleton.conf \
#		$(DEFAULTS_DIR)/etc/

.PHONY: configure clean build install

