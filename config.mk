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

ifeq ($(wildcard $(TOP_DIR)/local.mk), $(TOP_DIR)/local.mk)
include $(TOP_DIR)/local.mk
endif

# cflinux version
RELEASE_STRING := $(shell $(TOP_DIR)/tools/GIT_VERSION_GEN)
VERSION_MAJOR = $(shell echo $(RELEASE_STRING) | cut -d . -f 1)
VERSION_MINOR = $(shell echo $(RELEASE_STRING) | cut -d . -f 2- | cut -d p -f 1)
VERSION_PATCH = $(shell echo $(RELEASE_STRING) | cut -d . -f 2- | cut -d p -f 2- | cut -d - -f 1)
VERSION_EXTRA = $(shell echo $(RELEASE_STRING) | cut -d . -f 2- | cut -d p -f 2- | cut -d - -f 2-)

PACKAGE = cflinux

FDEVEL_DIR = $(TOP_DIR)

# target host
TARGET_HOST = i686-linux-uclibc
TARGET_ARCH = x86
TARGET_CC = $(TARGET_HOST)-gcc
TARGET_LD = $(TARGET_HOST)-ld
TARGET_AR = $(TARGET_HOST)-ar
TARGET_RANLIB = $(TARGET_HOST)-ranlib
TARGET_STRIP = $(TARGET_HOST)-strip -s

# The version of the used kernel
KERNEL_VERSION := 3.12.1

# the directory where uclibc will be installed
UC_ROOT=$(FDEVEL_DIR)/$(TARGET_HOST)

# the root of the target fs
ROOTFS:=$(FDEVEL_DIR)/fs_root

# PATH where the cross compiler is
UC_PATH		= PATH=$(UC_ROOT)/usr/bin:$(PATH)
UC_PATH_CROSS	= PATH=$(UC_ROOT)/bin:$(PATH)

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
MK := $(FDEVEL_DIR)/mk
CONFIGS := $(FDEVEL_DIR)/configs
INSTALL_BIN := $(TOP_DIR)/install_bin.sh
INSTALL_SCRIPT := install

INSTALL := install

MKCRAMFS := $(TOP_DIR)/tools/mkcramfs
PACKROOT := $(TOP_DIR)/tools/rootfs-pack
