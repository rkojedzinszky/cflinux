# Makefile for poptop
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

PKG := poptop
SRC_FILENAME = pptpd-1.1.3-20030409.tar.gz
EXTRACTED_DIR = poptop
DOWNLOAD_SITES = \
	http://heanet.dl.sourceforge.net/sourceforge/poptop/ \
	http://aleron.dl.sourceforge.net/sourceforge/poptop/ \
	http://umn.dl.sourceforge.net/sourceforge/poptop/

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); $(UC_PATH) \
		./configure --sysconfdir=/etc \
		--prefix=/usr)
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
	for i in pptpd pptpctrl ; do \
		$(INSTALL_BIN) $(PKG_ROOT)/$$i $(ROOTFS)/usr/sbin/ ; \
	done

.PHONY: configure clean build install
