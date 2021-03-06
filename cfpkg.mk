# 
# Common makefile for building cfpkgs for cflinux
#
# Copyright (C) 2005 Kojedzinszky Richard <krichy@tvnetwork.hu>
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

# This makefile is included in every packages makefile
# and contains common targets
#
# The package's makefile should contain the following variables:
# VERSION	- the version for the package

CFPKG_VERSION := 1.0

export CFPKG_PKG := $(PKG)
export CFPKG_DIR := $(shell pwd)
export TOP_DIR := $(shell cd $(CFLINUX_ROOT) && pwd)

# override some values
# the downloads dir, where the sources will reside
SOURCES_DIR = $(CFPKG_DIR)

# the packages' directory
PKG_PATCHES_DIR = $(CFPKG_DIR)/patches

# the work directory, where the compiling takes place
BUILD_DIR = $(CFPKG_DIR)/build

# the md5sums dir
MD5SUMS_DIR = $(CFPKG_DIR)

# where the package temporary installation should go?
PKG_INSTALL_DIR ?= $(BUILD_DIR)/_install

# the package version for cflinux
CFPKG_PKG_VERS = $(PKG_VERSION)$(PKG_VERSION_SUFF)

PKG_BASE ?= /usr/local

# the package information in the archive
PKG_CONF_DIR = _CFPKG

PKG_PACK_DIR = $(PKG_INSTALL_DIR)$(PKG_BASE)

PKG_INFO_FILE = $(PKG_PACK_DIR)/$(PKG_CONF_DIR)/INFO

PATCHES_DIR = $(PKG_PATCHES_DIR)

include $(TOP_DIR)/packages.mk

$(PKG_INSTALL_DIR):
	mkdir $(PKG_INSTALL_DIR) && chown 0:0 $(PKG_INSTALL_DIR) && chmod 755 $(PKG_INSTALL_DIR)

defaultperms:
	find $(PKG_PACK_DIR) -type d -print0 | xargs -r0 chmod 755
	find $(PKG_PACK_DIR) -type f -print0 | xargs -r0 chmod 444
	find $(PKG_PACK_DIR) -type f -path '*/bin/*' -print0 | xargs -r0 chmod 555
	find $(PKG_PACK_DIR) -type f -path '*/sbin/*' -print0 | xargs -r0 chmod 555
	find $(PKG_PACK_DIR) -type f -path '*/lib/*.so*' -print0 | xargs -r0 chmod 555
	chown -R 0:0 $(PKG_PACK_DIR)

pack: install permissions
	rm -rf $(PKG_PACK_DIR)/$(PKG_CONF_DIR)
	mkdir $(PKG_PACK_DIR)/$(PKG_CONF_DIR) && \
		cd $(PKG_PACK_DIR)/ && ( \
		find . -path './$(PKG_CONF_DIR)' -prune \
			-o -type d -mindepth 1 -printf 'd %p\n' ; \
		find . -path './$(PKG_CONF_DIR)' -prune \
			-o ! -type d -mindepth 1 -printf 'f %p\n' ; \
		true) > $(PKG_CONF_DIR)/FILES
	(echo "PKG_NAME=$(PKG)" && \
		echo "PKG_VERSION=$(CFPKG_PKG_VERS)" && \
		echo "PKG_BASE=$(PKG_BASE)" && \
		echo "PKG_FORMAT=2" && \
		echo "PKG_CFLINUX_MAJOR=$(VERSION_MAJOR)") \
		> $(PKG_INFO_FILE)
ifneq ($(DEPENDS),)
	for i in $(DEPENDS) ; do echo "$$i" ; done \
		> $(PKG_PACK_DIR)/$(PKG_CONF_DIR)/DEPENDS
endif
	# install messages if they exist
	-cp INST_MSG $(PKG_PACK_DIR)/$(PKG_CONF_DIR)/

	# install (pre|post)(install|rm) files
	-install -m 555 -o 0 -g 0 PREINSTALL POSTINSTALL PRERM POSTRM $(PKG_PACK_DIR)/$(PKG_CONF_DIR)/

	# install rc script if found
	if [ -f rc.d ]; then install -m 555 -o 0 -g 0 -d $(PKG_INSTALL_DIR)/usr/local/etc/rc.d ; \
		install -m 555 -o 0 -g 0 rc.d $(PKG_INSTALL_DIR)/usr/local/etc/rc.d/$(PKG) ; fi

	cd "$(PKG_PACK_DIR)" && tar czf "$(CFPKG_DIR)/../$(PKG)-$(CFPKG_PKG_VERS).cfpkg" *
