# Makefile for finish
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

# Removes unnecessary dirs from the root
# include the common package targets 
include $(TOP_DIR)/config.mk

download:

extract:

patch:

configure:

clean:

build:

install:
	rm -rf $(ROOTFS)/usr/share/man $(ROOTFS)/usr/man
	rm -rf $(ROOTFS)/usr/share/doc
	rm -rf $(ROOTFS)/usr/local/*
	rm -rf $(ROOTFS)/usr/info
	rm -rf $(ROOTFS)/man
	rm -rf $(ROOTFS)/include
	rm -rf $(ROOTFS)/etc/*
	rm -rf $(ROOTFS)/sbin/rc?.d
	find $(ROOTFS)/lib/modules/$(KERNEL_VERSION)/ -name '*.o' -print0 | \
		xargs -0 strip -g
	PATH=/bin:/sbin:/usr/bin:/usr/sbin depmod -raeb $(ROOTFS) -F $(BUILD_DIR)/kernel/System.map $(KERNEL_VERSION)
	rm -f fs_config/modules.conf

.PHONY: configure clean build install
