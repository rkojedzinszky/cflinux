#   FILE: cfpkg_common.sh -- common routines for cfpkg handling
# AUTHOR: Richard Kojedzinszky <krichy@cflinux.h>
#   DATE: 30 August 2005
#
# Copyright (C) 2005 krichy <krichy@cflinux.hu>
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

# this is included in all cfpkg_*.sh

# log function
log ()
{
	[ "$_pkg_verbose" -lt "$1" ] && return
	shift
	echo "$@"
}

# check for the first instance
if [ -z "$_pkg_base" ]; then
	# the mount point for packages, and other cfpkg related files
	_pkg_base="/usr/local"

	# the packages database location
	_pkg_db="$_pkg_base/var/db/pkg"

	# the package's config directory
	_pkg_config="_CFPKG"

	# define some global values, and process options
	[ -z "$_pkg_verbose" ] && _pkg_verbose=0
	_pkg_recurse=

	# clear the version variables
	_cflinux_major= _cflinux_minor= _cflinux_patch= _cflinux_extra=
	# read them in
	. /usr/lib/cfpkg/cflinux_version
	# export them
	export _cflinux_major _cflinux_minor _cflinux_patch _cflinux_extra

	while : ; do
		case "$1" in
			-v)
				let "_pkg_verbose++"
				;;
			-r)
				_pkg_recurse="$1"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [ "$#" -ne "1" ]; then
		echo "Usage: $0 [options] package"
		echo "Options: -v: increase verbosity"
		echo "         -r: enable recursive mode (only for removal)"
		exit 1
	fi

	# export _pkg_verbose earlier
	export _pkg_verbose

	# the state of the mount point
	_pkg_base_state=$(awk "\$2 == \"$_pkg_base\" {print \$4}" /proc/mounts \
			| sed 's/^.*\(r[ow]\).*$/\1/')

	# test the state of it
	if [ -z "$_pkg_base_state" ] ; then
		echo "$_pkg_base is not mounted yet, you must initialize it!"
		exit 1
	fi

	# remount it rw if needed
	if [ "$_pkg_base_state" = "ro" ] ; then
		mount -o remount,rw "$_pkg_base"
	fi

	# check the db dir
	if [ ! -d "$_pkg_db" ] ; then
		echo "Running for the first time, initializing database..."
		mkdir -p "$_pkg_db"
		echo "... done"
	fi

	# create a temporary dir
	umask 077
	while : ; do
		_pkg_tmpdir="/tmp/$RANDOM"
		if mkdir "$_pkg_tmpdir" >/dev/null 2>&1 ; then
			break
		fi
	done

	# export variables for the second instance
	export _pkg_base _pkg_db _pkg_base_state _pkg_tmpdir _pkg_config _pkg_recurse

	# call us again but with the exported variables
	$0 "$@"

	# save the return value
	rv=$?

	# remove the temp directory
	rm -rf "$_pkg_tmpdir"

	# remount $_pkg_base ro if needed
	if [ "$_pkg_base_state" = "ro" ] ; then
		mount -o remount,ro "$_pkg_base"
	fi

	exit $rv
fi

# set a default umask
umask 022
