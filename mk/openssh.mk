# Makefile for openssh
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

PKG := openssh
SRC_FILENAME = openssh-3.8p1.tar.gz
EXTRACTED_DIR = openssh-3.8p1
DOWNLOAD_SITES = \
	ftp://ftp.fsn.hu/pub/OpenBSD/OpenSSH/portable/ \
	ftp://ftp.ca.openbsd.org/pub/OpenBSD/OpenSSH/portable/ \
	ftp://ftp.iij.ad.jp/pub/OpenBSD/OpenSSH/portable/ \
	ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/
PATCHES = openssh.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT) ; $(UC_PATH) ./configure \
	 	--prefix=/usr --sysconfdir=/etc/ssh \
		--localstatedir=/var --without-shadow \
		--with-pid-dir=/var/run \
		--with-zlib=../zlib --with-ssl-dir=../openssl \
		--with-md5-passwords --disable-largefile)
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
	$(INSTALL_BIN) $(PKG_ROOT)/ssh $(ROOTFS)/usr/bin
	$(INSTALL_BIN) $(PKG_ROOT)/sshd $(ROOTFS)/usr/sbin
	$(INSTALL_BIN) $(PKG_ROOT)/ssh-keygen $(ROOTFS)/usr/sbin
	$(INSTALL_BIN) $(PKG_ROOT)/scp $(ROOTFS)/usr/bin
	$(INSTALL_BIN) $(PKG_ROOT)/libssh.so $(ROOTFS)/usr/lib
	mkdir -p $(DEFAULTS_DIR)/etc/ssh
	for i in ssh_config moduli; do \
		cp $(PKG_ROOT)/$$i $(DEFAULTS_DIR)/etc/ssh/ ; done
	sed -e 's/^#Protocol.*$$/Protocol 2/g' \
		-e 's/^Subsystem/#Subsystem/' \
		-e 's/^#\?ChallengeResponseAuthentication.*$$/ChallengeResponseAuthentication no/' \
		$(PKG_ROOT)/sshd_config \
		> $(DEFAULTS_DIR)/etc/ssh/sshd_config

.PHONY: configure clean build install
