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
		ftp://ftp.hu.kernel.org/pub/linux/kernel/v2.6/ \
		ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.6/ \
		ftp://ftp.se.kernel.org/pub/linux/kernel/v2.6/ \
		ftp://ftp.sm.kernel.org/pub/linux/kernel/v2.6/ \
		ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ \
		$(CFLINUX_PACKAGES)
PATCHES = kernel.vlan_mtu.patch \
	kernel.init.patch \
	kernel.blackhole.patch \
	kernel.usb_root.patch \
	kernel.igmp.c.max_membership.patch \
	kernel.inline_kfree_skb.patch \
	kernel.asm_types_h.patch \
	kernel.lef.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

E1000_STAMP=$(PKG_ROOT)/.e1000_applied

configure: patch e1000patch $(CONFIGURED_STAMP)

e1000patch: $(E1000_STAMP)

$(E1000_STAMP): $(BUILD_DIR)/e1000/.e1000.patched
	rm -f $(PKG_ROOT)/drivers/net/e1000/*.[ch]
	cp $(BUILD_DIR)/e1000/src/*.[ch] $(PKG_ROOT)/drivers/net/e1000/
	sed -i"" -e "s/^e1000-objs.*$$/e1000-objs	:= $$(cd $(PKG_ROOT)/drivers/net/e1000 && echo *.c|sed 's/\.c/\.o/g')/" \
		$(PKG_ROOT)/drivers/net/e1000/Makefile
	touch $@

$(BUILD_DIR)/e1000/.e1000.patched:
	$(MAKE) -f mk/e1000.mk patch

ifeq ($(wildcard $(CONFIGS)/$(PKG).config.patch),$(CONFIGS)/$(PKG).config.patch)
CFGPATCH = $(CONFIGS)/$(PKG).config.patch
else
CFGPATCH =
endif

$(CONFIGURED_STAMP):
	cp $(CONFIGS)/$(PKG).config $(PKG_ROOT)/.config
	(cd $(PKG_ROOT) && for i in $(CFGPATCH) ; do patch < $$i ; done)
	$(MAKE) -C $(PKG_ROOT) oldconfig
	touch $@

clean:
	$(MAKE) -C $(PKG_ROOT) clean
	rm -f $(CONFIGURED_STAMP) $(BUILT_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) bzImage modules -j4
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) modules_install INSTALL_MOD_PATH=$(ROOTFS)

.PHONY: configure clean build install

