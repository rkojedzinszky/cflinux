# Makefile for vtun
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

PKG := vtun
SRC_FILENAME = vtun-2.6.tar.gz
EXTRACTED_DIR = vtun
DOWNLOAD_SITES = \
		http://switch.dl.sourceforge.net/sourceforge/vtun/ \
		http://keihanna.dl.sourceforge.net/sourceforge/vtun/ \
		http://belnet.dl.sourceforge.net/sourceforge/vtun/ \
		http://cesnet.dl.sourceforge.net/sourceforge/vtun/ \
		http://aleron.dl.sourceforge.net/sourceforge/vtun/ \
		$(CFLINUX_PACKAGES)
PATCHES = vtun.configure.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT) && $(UC_PATH) ./configure --prefix=/usr \
	--sysconfdir=/etc --disable-lzo \
	--with-ssl-headers=../openssl/include/openssl --with-ssl-libs=../openssl)
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/vtund $(ROOTFS)/usr/sbin/
	$(INSTALL) -o 0 -g 0 -m 444 $(PKG_ROOT)/vtund.conf $(DEFAULTS_DIR)/etc/

.PHONY: configure clean build install
