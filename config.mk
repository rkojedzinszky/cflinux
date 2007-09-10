#
# configuration for compact flash linux project
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
# the top level dir
#

# cflinux version
VERSION_MAJOR = 2
VERSION_MINOR = 0
VERSION_PATCH = 5-pre

RELEASE_STRING := $(VERSION_MAJOR).$(VERSION_MINOR)
ifneq ($(VERSION_PATCH),)
RELEASE_STRING := $(RELEASE_STRING)p$(VERSION_PATCH)
endif
ifneq ($(VERSION_EXTRA),)
RELEASE_STRING := $(RELEASE_STRING)-$(VERSION_EXTRA)
endif
PACKAGE = cflinux

export FDEVEL_DIR := $(TOP_DIR)

# the directory where uclibc will be installed
export UC_ROOT=$(FDEVEL_DIR)/i386-linux-uclibc

# the root of the target fs
export ROOTFS:=$(FDEVEL_DIR)/fs_root

# PATH where the uclibc's gcc is
UC_PATH		= PATH=$(UC_ROOT)/usr/bin:$(UC_ROOT)/bin:$(PATH)
UC_PATH_CROSS	= PATH=$(UC_ROOT)/bin:$(PATH)
export UC_PATH UC_PATH_CROSS

UC_ENV := LD_LIBRARY_PATH=$(UC_ROOT)/lib
UC_ENV += $(UC_PATH)
export UC_ENV

# target host
TARGET_HOST = i386-uclibc-linux-gnu
export TARGET_HOST

# The version of the used kernel
KERNEL_VERSION := 2.6.21.5

# the downloads dir, where the sources will reside
SOURCES_DIR ?= $(TOP_DIR)/sources

# the patches' directory
PATCHES_DIR ?= $(TOP_DIR)/patches

# the work directory, where the compiling takes place
BUILD_DIR ?= $(TOP_DIR)/build

# md5 sums directory
MD5SUMS_DIR ?= $(TOP_DIR)/md5sums

# the default's dir
DEFAULTS_DIR = $(ROOTFS)/usr/share/defaults

# the cflinux's package site as a last resort for packages
CFLINUX_PACKAGES = ftp://ftp.cflinux.hu/pub/cflinux/packages/

ifeq ($(TOP_DIR),)
export TOP_DIR := $(shell pwd)
endif
export MK := $(FDEVEL_DIR)/mk
export CONFIGS := $(FDEVEL_DIR)/configs
export INSTALL_BIN := $(TOP_DIR)/install_bin.sh
export INSTALL_SCRIPT := install -m 555

INSTALL := install

MKCRAMFS := $(TOP_DIR)/tools/mkcramfs
PACKROOT := $(TOP_DIR)/tools/rootfs-pack
