# Makefile for rp-l2tp
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

PKG := rp-l2tp
SRC_FILENAME = rp-l2tp-0.4.tar.gz
EXTRACTED_DIR = rp-l2tp-0.4
DOWNLOAD_SITES = \
	http://belnet.dl.sourceforge.net/sourceforge/rp-l2tp/ \
	http://ovh.dl.sourceforge.net/sourceforge/rp-l2tp/ \
	http://optusnet.dl.sourceforge.net/sourceforge/rp-l2tp/ \
	http://voxel.dl.sourceforge.net/sourceforge/rp-l2tp/ \
	http://umn.dl.sourceforge.net/sourceforge/rp-l2tp/ \
	http://keihanna.dl.sourceforge.net/sourceforge/rp-l2tp/

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT) && $(UC_PATH) ./configure \
	 --prefix=/usr)
	touch $(CONFIGURED_STAMP)

clean:
	-$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/l2tpd $(ROOTFS)/usr/sbin/
	$(INSTALL_BIN) $(PKG_ROOT)/handlers/l2tp-control $(ROOTFS)/usr/sbin/
	-$(INSTALL) -d -m 555 -o 0 -g 0 $(ROOTFS)/usr/lib/l2tp
	-$(INSTALL) -d -m 555 -o 0 -g 0 $(ROOTFS)/usr/lib/l2tp/plugins/
	$(INSTALL_BIN) $(PKG_ROOT)/handlers/cmd.so $(ROOTFS)/usr/lib/l2tp/plugins/
	$(INSTALL_BIN) $(PKG_ROOT)/handlers/sync-pppd.so $(ROOTFS)/usr/lib/l2tp/plugins/
	
	-$(INSTALL) -o 0 -g 0 -m 555 -d $(DEFAULTS_DIR)/etc/l2tp
	$(INSTALL) -m 444 -o 0 -g 0 $(PKG_ROOT)/l2tp.conf $(DEFAULTS_DIR)/etc/l2tp/

.PHONY: configure clean build install