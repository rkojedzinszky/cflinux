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
SRC_FILENAME = linux-$(KERNEL_VERSION).tar.xz
EXTRACTED_DIR = linux-$(KERNEL_VERSION)
KERNEL_DIR = $(shell echo $(KERNEL_VERSION) | sed 's/^2\.6\..*$$/v2.6/;s/^3\..*$$/v3.x/')

DOWNLOAD_SITES = \
		ftp://ftp.hu.kernel.org/pub/linux/kernel/$(KERNEL_DIR) \
		ftp://ftp.nl.kernel.org/pub/linux/kernel/$(KERNEL_DIR) \
		ftp://ftp.se.kernel.org/pub/linux/kernel/$(KERNEL_DIR) \
		ftp://ftp.sm.kernel.org/pub/linux/kernel/$(KERNEL_DIR) \
		ftp://ftp.kernel.org/pub/linux/kernel/$(KERNEL_DIR) \
		$(CFLINUX_PACKAGES)
PATCHES = \
	kernel.wireless_regulatory.patch \
	kernel.init.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

ifeq ($(wildcard $(CONFIGS)/$(PKG).config.patch),$(CONFIGS)/$(PKG).config.patch)
CFGPATCH = $(CONFIGS)/$(PKG).config.patch
else
CFGPATCH =
endif

KERNEL_COMMON = LOCALVERSION= ARCH=$(TARGET_ARCH) CROSS_COMPILE=$(TARGET_HOST)-

$(CONFIGURED_STAMP):
	cp $(CONFIGS)/$(PKG).config $(PKG_ROOT)/.config
	(cd $(PKG_ROOT) && for i in $(CFGPATCH) ; do patch < $$i ; done)
	$(MAKE) -C $(PKG_ROOT) oldconfig $(KERNEL_COMMON)
	touch $@

clean:
	$(MAKE) -C $(PKG_ROOT) clean $(KERNEL_COMMON)
	rm -f $(CONFIGURED_STAMP) $(BUILT_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) bzImage modules -j4 $(KERNEL_COMMON)
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) modules_install INSTALL_MOD_PATH=$(ROOTFS) $(KERNEL_COMMON)

.PHONY: configure clean build install

