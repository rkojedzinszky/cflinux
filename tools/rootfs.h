/*   FILE: rootfs.h -- 
 * AUTHOR: Richard Kojedzinszky <krichy@cflinux.hu>
 *   DATE: 23 April 2006
 *
 * Copyright (C) 2006 Richard Kojedzinszky <krichy@cflinux.hu>
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef _ROOTFS_H
#define _ROOTFS_H

#include <linux/types.h>
#include <openssl/sha.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CFLINUX_ROOTFS_MAGIC		"cflinux-rootfs"

/* the rootfs file's structure is explained here:
 * for compatibility reasons, the whole file must begin with the root filesystem,
 * no headers are allowed.
 * after the fs, an optional tar.gz file follows, which will be extracted into a
 * temporary directory, and if a file named setup exists, it is called before the
 * rootfs is written into the root device. also, this script must return 0 to allow
 * the writing process to continue
 */
 
/* the rootfs header struct */
struct rootfs_hdr_t {
	__s8					magic[16];			/* contains 'cflinux-rootfs' */
	__s32					header_v;			/* rootfs.bin's header version */
	__s32					v_major;			/* major version */
	__s32					v_minor;			/* minor version */
	__s32					v_patch;			/* patch version */
	__u8					v_extra[16];			/* extra version string */
	__u32					rootfs_l;			/* the length of the root filesystem */
	__u32					tar_l;				/* the length of the tar file */
	__u8					md[SHA_DIGEST_LENGTH];
										/* the sha1 sum of the whole archive
										 * this MUST be the last */
};
#ifdef __cplusplus
}
#endif

#endif /* _ROOTFS_H */

/*
 * vim: ts=2 sw=2
 */
