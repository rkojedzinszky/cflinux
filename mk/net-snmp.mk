# Makefile for net-snmp
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

PKG := net-snmp
SRC_FILENAME = net-snmp-5.1.tar.gz
EXTRACTED_DIR = net-snmp-5.1
DOWNLOAD_SITES = \
		http://heanet.dl.sourceforge.net/sourceforge/net-snmp/ \
		http://unc.dl.sourceforge.net/sourceforge/net-snmp/ \
		$(CFLINUX_PACKAGES)
PATCHES = net-snmp.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); $(UC_PATH) ./configure \
	 --prefix=/usr --sysconfdir=/etc \
	 --disable-applications --disable-scripts \
	 --disable-debugging --enable-shared \
	 --with-openssl=../openssl --without-root-access \
	 --with-sys-contact="net-admin@" \
	 --with-mib-modules="host" \
	 --with-default-snmp-version=3 --with-sys-location="default" \
	 --with-logfile=/var/log/snmpd.log \
	 --with-persistent-directory=/var/lib/net-snmp \
	 --localstatedir=/var/run \
	 --without-rpm )
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
	for i in agent mibs ; do \
		$(INSTALL_BIN_NS) $(PKG_ROOT)/agent/.libs/libnetsnmp$${i}.so.5 \
			$(ROOTFS)/usr/lib/ ; done
	for i in helpers ; do \
		$(INSTALL_BIN_NS) \
		$(PKG_ROOT)/agent/helpers/.libs/libnetsnmp$${i}.so.5 \
			$(ROOTFS)/usr/lib/ ; done
	$(INSTALL_BIN_NS) $(PKG_ROOT)/snmplib/.libs/libnetsnmp.so.5 \
			$(ROOTFS)/usr/lib/
	$(INSTALL_BIN) $(PKG_ROOT)/agent/.libs/snmpd \
		$(ROOTFS)/usr/sbin/


.PHONY: configure clean build install
