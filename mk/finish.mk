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
	rm -rf $(ROOTFS)/usr/share/man
	rm -rf $(ROOTFS)/usr/info
	rm -rf $(ROOTFS)/man
	rm -rf $(ROOTFS)/include
	chown -R 0:0 $(FDEVEL_DIR)/fs_config
	chown -R 0:0 $(ROOTFS)
	chown -R 10:10 $(FDEVEL_DIR)/fs_config/zebra
	chmod 700 $(FDEVEL_DIR)/fs_config/zebra
	rm -rf $(ROOTFS)/etc/*

.PHONY: configure clean build install
