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
		ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ \
		$(CFLINUX_PACKAGES)
PATCHES = kernel.vlan_mtu.patch \
	kernel.mppe.patch \
	kernel.multigate.patch \
	kernel.init.patch \
	kernel.blackhole.patch \
	kernel.usb_root.patch \
	kernel.tulip_iff_running.patch \
	kernel.pcmcia-ti-routing-10_v24.patch \
	kernel.ipt_random.patch \
	kernel.igmp.c.max_membership.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

OPENSWAN_STAMP=$(PKG_ROOT)/.openswan_applied
GRSEC_STAMP=$(PKG_ROOT)/.grsec_applied
E1000_STAMP=$(PKG_ROOT)/.e1000_applied

configure: patch openswanpatch grsecpatch e1000patch $(CONFIGURED_STAMP)

openswanpatch: $(OPENSWAN_STAMP)
grsecpatch: $(GRSEC_STAMP)
e1000patch: $(E1000_STAMP)

$(OPENSWAN_STAMP): $(BUILD_DIR)/openswan/.openswan.patched
	(cd $(PKG_ROOT); \
	$(MAKE) -C $(BUILD_DIR)/openswan kernelpatch2.4 | patch -p1)
	touch $@

$(GRSEC_STAMP): $(BUILD_DIR)/grsec/.grsec.patched
	(cd $(PKG_ROOT) && find $(BUILD_DIR)/grsec/ \
	 -type f -name '*.patch' | xargs cat | \
	 patch -p1)
	touch $@

$(E1000_STAMP): $(BUILD_DIR)/e1000/.e1000.patched
	cp $(BUILD_DIR)/e1000/src/*.[ch] $(PKG_ROOT)/drivers/net/e1000/
	sed -i"" -e '/^obj-y/a\obj-y	+= kcompat.o' $(PKG_ROOT)/drivers/net/e1000/Makefile
	touch $@

$(BUILD_DIR)/grsec/.grsec.patched:
	$(MAKE) -f mk/grsec.mk patch

$(BUILD_DIR)/openswan/.openswan.patched:
	$(MAKE) -f mk/openswan.mk patch

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
	$(MAKE) -C $(PKG_ROOT) bzImage modules
	touch $(BUILT_STAMP)

install: build
	$(MAKE) -C $(PKG_ROOT) modules_install INSTALL_MOD_PATH=$(ROOTFS)
	(cd $(ROOTFS)/lib/modules/$(KERNEL_VERSION)/kernel/net/sched && \
	 for i in 0 1 2 3 4 5 6 7; do ln -f sch_teql.o teql$$i.o ; done)
	(cd $(ROOTFS)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/net && \
	 for i in 0 1 2 3 4 5 6 7; do ln -f dummy.o dummy$$i.o ; \
	 ln -f bonding/bonding.o bonding/bond$$i.o ; done)

.PHONY: configure clean build install

