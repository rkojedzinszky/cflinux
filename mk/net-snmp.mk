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
SRC_FILENAME = net-snmp-5.2.3.tar.gz
EXTRACTED_DIR = net-snmp-5.2.3
DOWNLOAD_SITES = \
		http://heanet.dl.sourceforge.net/sourceforge/net-snmp/ \
		http://unc.dl.sourceforge.net/sourceforge/net-snmp/ \
		$(CFLINUX_PACKAGES)
PATCHES = net-snmp.vmstat.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT); $(UC_PATH) ./configure --host=$(TARGET_HOST) \
	 --with-endianness=little \
	 --prefix=/usr \
	 --sysconfdir=/etc \
	 --disable-scripts \
	 --disable-debugging \
	 --enable-shared \
	 --with-openssl=../openssl \
	 --without-root-access \
	 --with-sys-contact="net-admin@" \
	 --with-mib-modules="host smux disman/event-mib" \
	 --with-default-snmp-version=3 \
	 --with-sys-location="default" \
	 --with-logfile=/var/log/snmpd.log \
	 --with-persistent-directory=/var/lib/net-snmp \
	 --localstatedir=/var/run \
	 --enable-local-smux \
	 --without-rpm \
	 --enable-ucd-snmp-compatibility )
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) all $(UC_PATH)
	$(MAKE) -C $(PKG_ROOT) installheaders installlibs INSTALL_PREFIX=$(UC_ROOT) $(UC_PATH)
	touch $(BUILT_STAMP)

install: build
	for i in agent mibs ; do \
		for j in $(PKG_ROOT)/agent/.libs/libnetsnmp$${i}.so.9* ; do \
			$(INSTALL_BIN) $${j} \
				$(ROOTFS)/usr/lib/ ; done ; done
	for i in helpers ; do \
		for j in $(PKG_ROOT)/agent/helpers/.libs/libnetsnmp$${i}.so.9* ; do \
			$(INSTALL_BIN) $${j} \
				$(ROOTFS)/usr/lib/ ; done ; done
	for i in $(PKG_ROOT)/snmplib/.libs/libnetsnmp.so.9* ; do \
		$(INSTALL_BIN) $${i} \
			$(ROOTFS)/usr/lib/ ; done
#	$(INSTALL_BIN) $(PKG_ROOT)/apps/.libs/snmptrap \
#		$(ROOTFS)/usr/bin/
	$(INSTALL_BIN) $(PKG_ROOT)/agent/.libs/snmpd \
		$(ROOTFS)/usr/sbin/
#	$(MAKE) -C $(PKG_ROOT)/mibs mibsinstall INSTALL_PREFIX=$(ROOTFS)

.PHONY: configure clean build install
