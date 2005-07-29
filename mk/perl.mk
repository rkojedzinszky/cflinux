# Makefile for perl
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

PKG := perl
SRC_FILENAME = perl-5.8.7.tar.gz
EXTRACTED_DIR = perl-5.8.7
DOWNLOAD_SITES = http://www.perl.com/CPAN/src/		# look at \
							# the ending \
							# dash
PATCHES = perl.Configure.patch \
	  perl.perlio_c.patch

# include the common package targets 
include $(TOP_DIR)/packages.mk 

configure: patch $(CONFIGURED_STAMP)

$(CONFIGURED_STAMP):
	(cd $(PKG_ROOT) && rm -f config.sh Policy.sh && \
	 UC_ROOT=$(UC_ROOT) $(UC_PATH) sh Configure -de \
	 -Uuselargefiles -Ui_shadow -Dd_dosuid -Di_db -Duseposix)
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
	-mkdir $(PKG_ROOT)/_install
	$(MAKE) -C $(PKG_ROOT) \
		install.perl STRIPFLAGS=-s DESTDIR=$(PKG_ROOT)/_install
	cd $(PKG_ROOT)/_install/usr/local && \
		tar czf $(PKG_ROOT)/$(PKG).tgz bin lib

.PHONY: configure clean build install

