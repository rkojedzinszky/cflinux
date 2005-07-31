# 
# Common rules for the packages' makefiles
#
# Copyright (C) 2004 Kojedzinszky Richard <krichy@tvnetwork.hu>
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
# SRC_FILENAME	- the source file name, in compressed format
# EXTRACTED_DIR - the extracted directory name
# DOWNLOAD_SITES - where to download from the source
# PATCHES - the list of patches that need to be applied

include $(TOP_DIR)/config.mk

PKG_ROOT ?= $(BUILD_DIR)/$(EXTRACTED_DIR)

EXTRACTED_STAMP = $(BUILD_DIR)/.$(PKG).extracted
PATCHED_STAMP = $(PKG_ROOT)/.$(PKG).patched
CONFIGURED_STAMP = $(PKG_ROOT)/.$(PKG).configured
BUILT_STAMP = $(PKG_ROOT)/.$(PKG).built

download: $(SOURCES_DIR)/$(SRC_FILENAME)

$(SOURCES_DIR)/$(SRC_FILENAME):
	@test -d "$(SOURCES_DIR)" || mkdir "$(SOURCES_DIR)"
	@for i in $(DOWNLOAD_SITES); do \
		echo "Downloading $(SRC_FILENAME)" ; \
		wget -T 60 -t 1 -P $(SOURCES_DIR) "$$i/$(SRC_FILENAME)" && break ; \
	done

extract: download $(EXTRACTED_STAMP)

$(EXTRACTED_STAMP):
	@test -d "$(BUILD_DIR)" || mkdir "$(BUILD_DIR)"
	@(echo -n "Checking integrity of $(PKG): " ; cd "$(SOURCES_DIR)" ; \
	 if md5sum -c "$(MD5SUMS_DIR)/$(SRC_FILENAME).md5" ; then \
		echo "valid" ; else echo "failed" ; exit 1 ; fi)
	@echo -n "Extracting $(PKG): "
	@if echo "$(SRC_FILENAME)" | grep -qE "\.t(ar\.)?gz$$" ; then \
		tar xzf "$(SOURCES_DIR)/$(SRC_FILENAME)" -C "$(BUILD_DIR)" ; \
	elif echo "$(SRC_FILENAME)" | grep -qE "\.t(ar\.)?bz2$$" ; then \
		tar xjf "$(SOURCES_DIR)/$(SRC_FILENAME)" -C "$(BUILD_DIR)" ; \
	else echo "Cannot handle $(SRC_FILENAME)"; exit 1; fi
	@echo "done"
	@[ "$(EXTRACTED_DIR)" = "$(PKG)" ] || \
		ln -sf "$(EXTRACTED_DIR)" "$(BUILD_DIR)/$(PKG)"
	@touch $@

patch: extract $(PATCHED_STAMP)

$(PATCHED_STAMP):
	@echo -n "Patching $(PKG): "
ifeq ($(PKG_PATCHES_DIR),)
	@cd $(PKG_ROOT); for i in $(PATCHES); do \
		patch -p1 < "$(PATCHES_DIR)/$$i" >/dev/null || exit 1 ; \
		echo -n " [$$i]" ; done
else
	@cd $(PKG_ROOT) && for i in $(PKG_PATCHES_DIR)/*.patch ; do \
		[ -f "$$i" ] && echo -n " [$$i" && patch -p1 < "$$i" > /dev/null \
		&& echo -n "]" ; done
endif
	@echo " done"
	@touch $@

distclean:
	rm -rf "$(PKG_ROOT)" "$(BUILD_DIR)/$(PKG)" "$(EXTRACTED_STAMP)"
