# Makefile for kernel
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
#
# $Id$

PKG := kernel
SRC_FILENAME = linux-$(KERNEL_VERSION).tar.bz2
EXTRACTED_DIR = linux-$(KERNEL_VERSION)
DOWNLOAD_SITES = \
		ftp://ftp.hu.kernel.org/pub/linux/kernel/v2.4/ \
		ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/ \
		ftp://ftp.se.kernel.org/pub/linux/kernel/v2.4/ \
		ftp://ftp.sm.kernel.org/pub/linux/kernel/v2.4/ \
		ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
PATCHES = kernel.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

FREESWAN_STAMP=$(PKG_ROOT)/.freeswan_applied

configure: patch freeswanpatch $(CONFIGURED_STAMP)

freeswanpatch: $(FREESWAN_STAMP)

$(FREESWAN_STAMP): $(BUILD_DIR)/freeswan/.freeswan.patched
	(cd $(PKG_ROOT); \
	$(MAKE) -C $(BUILD_DIR)/freeswan kernelpatch2.4 | patch -p1)
	touch $@

$(BUILD_DIR)/freeswan/.freeswan.patched:
	$(MAKE) -f mk/freeswan.mk patch

$(CONFIGURED_STAMP):
	cp $(CONFIGS)/$(PKG).config $(PKG_ROOT)/.config
	$(MAKE) -C $(PKG_ROOT) oldconfig
	touch $@

clean:
	$(MAKE) -C $(PKG_ROOT) clean
	rm -f $(CONFIGURED_STAMP) $(BUILT_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) bzImage modules
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) modules_install INSTALL_MOD_PATH=$(ROOTFS)
	(cd $(ROOTFS)/lib/modules/$(KERNEL_VERSION)/kernel/net/sched && \
	 for i in 0 1 2 3 4 5 6 7; do ln -sf sch_teql.o teql$$i.o ; done)

.PHONY: configure clean build install

