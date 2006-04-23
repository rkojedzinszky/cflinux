/*   FILE: rootfs-pack.c -- 
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

#include <openssl/sha.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <netinet/in.h>
#include "rootfs.h"

extern int		errno;

/* this program will pack a root filesystem, an optional tar.gz into
 * a so-called cflinux.img
 * it must be called as:
 * ./pack <major> <minor> <patch> <extra> <rootfs.bin> <tar.gz> <cflinux.img>
 */

static	SHA_CTX	sc;		/* this is to make the digest of the data copied */
static
void		fdcopy(int in, int out, long count)
{
	char	buf[512];
	int		r, rr;

	while(count) {
		r = sizeof(buf) < count ? sizeof(buf) : count;
		rr = read(in, buf, r);
		if (rr != r) {
			fprintf(stderr, "read: could not read %d bytes, exiting\n", r);
			exit(EXIT_FAILURE);
		}
		if (write(out, buf, r) != r) {
			fprintf(stderr, "write: could not write %d bytes, exiting\n", r);
			exit(EXIT_FAILURE);
		}
		SHA1_Update(&sc, buf, r);
		count -= r;
	}
}

int			main(int argc, char* argv[])
{
	struct rootfs_hdr_t		rhdr;
	struct stat rst;
	struct stat tst;
	int ifd, ofd;

	if (argc != 8) {
		fprintf(stderr, "Usage: %s <major> <minor> <patch> <extra> <rootfs.bin> <tar.gz> <cflinux.img>\n",
				argv[0]);
		exit(EXIT_FAILURE);
	}

	strncpy(rhdr.magic, CFLINUX_ROOTFS_MAGIC, sizeof(rhdr.magic));
	rhdr.header_v = htonl(1);
	rhdr.v_major = htonl(atol(argv[1]));
	rhdr.v_minor = htonl(atol(argv[2]));
	rhdr.v_patch = htonl(atol(argv[3]));
	strncpy(rhdr.v_extra, argv[4], sizeof(rhdr.v_extra));

	if (stat(argv[5], &rst) == -1) {
		fprintf(stderr, "%s: stat: %s\n", argv[5], strerror(errno));
		exit(EXIT_FAILURE);
	}
	rhdr.rootfs_l = htonl((unsigned long)rst.st_size);
	if (stat(argv[6], &tst) == -1) {
		fprintf(stderr, "%s: stat: %s\n", argv[6], strerror(errno));
		exit(EXIT_FAILURE);
	}
	rhdr.tar_l = htonl((unsigned long)tst.st_size);

	ofd=open(argv[7], O_WRONLY|O_TRUNC|O_CREAT, 0777);
	if (ofd == -1) {
		fprintf(stderr, "%s: open: %s\n", argv[7], strerror(errno));
		exit(EXIT_FAILURE);
	}

	SHA1_Init(&sc);
	/* copy in rootfs.bin */
	ifd=open(argv[5], O_RDONLY);
	if (ifd == -1) {
		fprintf(stderr, "%s: open: %s\n", argv[5], strerror(errno));
		exit(EXIT_FAILURE);
	}
	fdcopy(ifd, ofd, rst.st_size);
	close(ifd);
	/* copy in tar.gz */
	ifd=open(argv[6], O_RDONLY);
	if (ifd == -1) {
		fprintf(stderr, "%s: open: %s\n", argv[6], strerror(errno));
		exit(EXIT_FAILURE);
	}
	fdcopy(ifd, ofd, tst.st_size);
	close(ifd);
	/* write the header */
	SHA1_Update(&sc, &rhdr, sizeof(rhdr)-SHA_DIGEST_LENGTH);
	SHA1_Final(rhdr.md, &sc);
	if (write(ofd, &rhdr, sizeof(rhdr)) != sizeof(rhdr)) {
		fprintf(stderr, "%s: write: %s\n", argv[7], strerror(errno));
		exit(EXIT_FAILURE);
	}
	close(ofd);
	exit(EXIT_SUCCESS);
}

/*
 * vim: ts=2 sw=2
 */
