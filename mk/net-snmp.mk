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
SRC_FILENAME = net-snmp-5.7.1.tar.gz
EXTRACTED_DIR = net-snmp-5.7.1
DOWNLOAD_SITES = \
		http://switch.dl.sourceforge.net/project/net-snmp/net-snmp/5.7.1/ \
		http://heanet.dl.sourceforge.net/sourceforge/net-snmp/ \
		http://unc.dl.sourceforge.net/sourceforge/net-snmp/ \
		$(CFLINUX_PACKAGES)

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	cd $(PKG_ROOT) && ./configure --host=$(TARGET_HOST) \
	 --with-endianness=little \
	 --prefix=/usr \
	 --sysconfdir=/etc \
	 --disable-applications \
	 --disable-manuals \
	 --disable-scripts \
	 --disable-mibs \
	 --disable-scripts \
	 --disable-embedded-perl \
	 --disable-mib-loading \
	 --with-perl-modules= \
	 --with-python-modules= \
	 --disable-debugging \
	 --enable-shared \
	 --disable-static \
	 --without-root-access \
	 --without-kmem-usage \
	 --with-nl=no \
	 --enable-ipv6 \
	 --with-mib-modules="smux" \
	 --with-default-snmp-version=3 \
	 --with-sys-contact="net-admin@" \
	 --with-sys-location="default" \
	 --with-logfile=/var/log/snmpd.log \
	 --with-persistent-directory=/var/lib/net-snmp \
	 --localstatedir=/var/run \
	 --enable-local-smux \
	 --without-rpm
	touch $(CONFIGURED_STAMP)

clean:
	$(MAKE) -C $(PKG_ROOT) distclean
	rm -f $(BUILT_STAMP)
	rm -f $(CONFIGURED_STAMP)

build: configure $(BUILT_STAMP)

$(BUILT_STAMP):
	$(MAKE) -C $(PKG_ROOT) sedscript standardall
	$(MAKE) -C $(PKG_ROOT) installheaders INSTALL_PREFIX=$(UC_ROOT)
	for i in agent mibs ; do \
		for j in $(PKG_ROOT)/agent/.libs/libnetsnmp$${i}.so.* ; do \
			$(INSTALL_BIN) $${j} \
				$(UC_ROOT)/usr/lib/ ; done ; done
	for i in helpers ; do \
		for j in $(PKG_ROOT)/agent/helpers/.libs/libnetsnmp$${i}.so.* ; do \
			$(INSTALL_BIN) $${j} \
				$(UC_ROOT)/usr/lib/ ; done ; done
	for i in $(PKG_ROOT)/snmplib/.libs/libnetsnmp.so.* ; do \
		$(INSTALL_BIN) $${i} \
			$(UC_ROOT)/usr/lib/ ; done
	touch $(BUILT_STAMP)

install: build
	$(INSTALL_BIN) $(PKG_ROOT)/agent/.libs/snmpd \
		$(ROOTFS)/usr/sbin/
	for i in agent mibs ; do \
		for j in $(PKG_ROOT)/agent/.libs/libnetsnmp$${i}.so.* ; do \
			$(INSTALL_BIN) $${j} \
				$(ROOTFS)/usr/lib/ ; done ; done
	for i in helpers ; do \
		for j in $(PKG_ROOT)/agent/helpers/.libs/libnetsnmp$${i}.so.* ; do \
			$(INSTALL_BIN) $${j} \
				$(ROOTFS)/usr/lib/ ; done ; done
	for i in $(PKG_ROOT)/snmplib/.libs/libnetsnmp.so.* ; do \
		$(INSTALL_BIN) $${i} \
			$(ROOTFS)/usr/lib/ ; done

.PHONY: configure clean build install
