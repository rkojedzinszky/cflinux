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

export FDEVEL_DIR := $(TOP_DIR)

# the directory where uclibc will be installed
export UC_ROOT=$(FDEVEL_DIR)/i386-linux-uclibc

# the root of the target fs
export ROOTFS:=$(FDEVEL_DIR)/fs_root

# PATH where the uclibc's gcc is
UC_PATH:= PATH=$(FDEVEL_DIR)/i386-linux-uclibc/usr/bin:$(PATH)
UC_ENV := LD_LIBRARY_PATH=$(FDEVEL_DIR)/i386-linux-uclibc/lib
UC_ENV += $(UC_PATH)
export UC_ENV
export UC_PATH

# the downloads dir, where the sources will reside
SOURCES_DIR = $(TOP_DIR)/sources

# the patches' directory
PATCHES_DIR = $(TOP_DIR)/patches

# the work directory, where the compiling takes place
BUILD_DIR = $(TOP_DIR)/build

export TOP_DIR := $(shell pwd)
export MK := $(FDEVEL_DIR)/mk
export CONFIGS := $(FDEVEL_DIR)/configs
export INSTALL_BIN := $(TOP_DIR)/install_bin.sh
export INSTALL_BIN_NS := install -s -o 0 -g 0 -m 755
export INSTALL_SCRIPT := install -o 0 -g 0 -m 755

INSTALL := install -o 0 -g 0
