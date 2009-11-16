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

PKG := toolchain

PKG_ROOT := $(TOP_DIR)/toolchain

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP): $(PKG_ROOT)/Makefile
	$(MAKE) DO_MK=kernel patch
	touch $(CONFIGURED_STAMP)

$(PKG_ROOT)/Makefile:
	git submodule init
	git submodule update

clean:
	$(MAKE) -C $(PKG_ROOT) clean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -j2 -C $(PKG_ROOT) all TARGET=$(TARGET_HOST) TROOT=$(UC_ROOT) KSRC=$(TOP_DIR)/build/kernel SRC=$(SOURCES_DIR)
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) install_runtime TARGET=$(TARGET_HOST) TROOT=$(UC_ROOT) KSRC=$(TOP_DIR)/build/kernel SRC=$(SOURCES_DIR) DESTDIR=$(ROOTFS)

.PHONY: configure clean build install

