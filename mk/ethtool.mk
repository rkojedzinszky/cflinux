# Makefile for ethtool
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

PKG := ethtool
SRC_FILENAME = ethtool-3.tar.gz
EXTRACTED_DIR = ethtool-3
DOWNLOAD_SITES = \
	http://kent.dl.sourceforge.net/sourceforge/gkernel/ \
	http://easynews.dl.sourceforge.net/sourceforge/gkernel/ \
	http://belnet.dl.sourceforge.net/sourceforge/gkernel/ \
	http://heanet.dl.sourceforge.net/sourceforge/gkernel/ \
	http://voxel.dl.sourceforge.net/sourceforge/gkernel/ \
	http://nchc.dl.sourceforge.net/sourceforge/gkernel/ \
	$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT) && \
	 $(UC_PATH) ./configure --prefix=/usr)
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/ethtool $(ROOTFS)/usr/sbin/

.PHONY: configure clean build install
