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

include $(TOP_DIR)/packages.mk

pack: install
	rm -rf $(PKG_ROOT)/_install/CONFIG && \
		mkdir $(PKG_ROOT)/_install/CONFIG && \
		cd $(PKG_ROOT)/_install/ && ( \
		find . -path ./CONFIG -prune -o \
			-type d -fprintf CONFIG/FILES 'd %p\n' ; \
		find . -path ./CONFIG -prune -o \
			-type f -fprintf CONFIG/FILES 'f %p\n' ; \
		true)
