/*   FILE: write_helper.c -- 
 * AUTHOR: krichy <krichy@tvnetwork.hu>
 *   DATE: 17 October 2003
 *
 * Copyright (C) 2003 krichy <krichy@tvnetwork.hu>
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
// vim: ts=4 sw=4

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include <sys/reboot.h>
#include <openssl/sha.h>
#include <netinet/in.h>
#include "rootfs.h"

extern int		errno;

#ifndef BSIZE
#define BSIZE	16384
#endif
static char		buffer[BSIZE];
static
struct rootfs_hdr_t		rhdr;
static
char					version[64];

static
void	error_and_die(char* fmt,...)
{
	va_list	va;

	va_start(va,fmt);
	vfprintf(stderr, fmt, va);
	va_end(va);
	exit(EXIT_FAILURE);
}

static
void			validate(char *src)
{
	SHA_CTX				sc;
	int						ifd;
	int						tl;
	int						cl;
	char*					v;
	struct stat		st;
	unsigned char	md[SHA_DIGEST_LENGTH];

	if (stat(src, &st) == -1)
		error_and_die("%s: stat: %s\n", src, strerror(errno));
	if ((ifd=open(src, O_RDONLY)) == -1)
		error_and_die("%s: open: %s\n", src, strerror(errno));
	lseek(ifd, -sizeof(rhdr), SEEK_END);
	if (read(ifd, &rhdr, sizeof(rhdr)) != sizeof(rhdr))
		error_and_die("%s: read: could not read %d bytes\n", src, sizeof(rhdr));
	if (memcmp(rhdr.magic, CFLINUX_ROOTFS_MAGIC, sizeof(CFLINUX_ROOTFS_MAGIC)-1))
		error_and_die("%s: does not like a valid cflinux image\n", src);
	if (htonl(rhdr.header_v) != 1)
		error_and_die("%s: wrong version detected\n", src);
	v = version;
	v += sprintf(v, "%d.%d", htonl(rhdr.v_major), htonl(rhdr.v_minor));
	if (htonl(rhdr.v_patch))
		v += sprintf(v, "p%d", htonl(rhdr.v_patch));
	if (rhdr.v_extra[0]) {
		v += sprintf(v, "-");
		memcpy(v, rhdr.v_extra, sizeof(rhdr.v_extra));
		v[sizeof(rhdr.v_extra)] = 0;
		v += strlen(v);
	}
	tl = htonl(rhdr.rootfs_l) + htonl(rhdr.tar_l) + sizeof(rhdr);
	if (tl != st.st_size)
		error_and_die("%s: inconsistency in file: length mismatch\n", src);
	tl -= SHA_DIGEST_LENGTH;

	/* validate the digest - need to check tl bytes */
	lseek(ifd, 0, SEEK_SET);
	SHA1_Init(&sc);
	cl = 0;
	while(cl < tl) {
		int r;
		r = tl - cl;
		if (r > BUFSIZ)
			r = BUFSIZ;
		if (read(ifd, buffer, r) != r)
			error_and_die("%s: could not read %d bytes\n", src, r);
		SHA1_Update(&sc, buffer, r);
		cl += r;
	}
	SHA1_Final(md, &sc);
	if (memcmp(rhdr.md, md, SHA_DIGEST_LENGTH))
		error_and_die("%s: sha1 checksum failed\n", src);
	close(ifd);
}

static
void	write_image(char* src, char* dst)
{
	int										percent;
	int										o_percent;
	int										ifh,ofh;
	unsigned long long		all;
	unsigned long long		done;

	percent=0;
	o_percent=-1;
	all=htonl(rhdr.rootfs_l);
	done=0;
	ifh=open(src,O_RDONLY);
	if ( ifh < 0 ) {
		error_and_die("open[source]: %s\n",strerror(errno));
	}
	ofh=open(dst,O_WRONLY);
	if ( ofh < 0 ) {
		error_and_die("open[dest]: %s\n",strerror(errno));
	}
	while( done < all ) {
		int s = all - done;
		if (s > BSIZE)
			s = BSIZE;
		if (read(ifh,buffer,s) != s)
			error_and_die("read[source]: %s\n", strerror(errno));
		if (write(ofh,buffer,s) != s)
			error_and_die("write[dest]: %s\n", strerror(errno));
		fsync(ofh);
		done+=s;
		percent=(int)((double)done*100.0/(double)all);
		if ( o_percent != percent ) {
			printf("\rWriting... [%3d%%]",percent);
			fflush(stdout);
			o_percent=percent;
		}
	}
	close(ofh);
	close(ifh);
}

static
void			prerun(char* src)
{
	int						ifd;
	char					tmpdir[] = "/tmp/cflinuxXXXXXX";
	char					rmcmd[32];
	FILE*					out;
	int						tot;
	struct stat		st;
	int						sstat = 0;
	char					cwd[PATH_MAX+1];

	if (htonl(rhdr.tar_l) == 0)
		return;

	if (getcwd(cwd, sizeof(cwd)) == NULL)
		error_and_die("getcwd() failed\n");
	if (mkdtemp(tmpdir) == NULL)
		error_and_die("failed to create temporary directory\n");
	if ((ifd=open(src, O_RDONLY)) == -1)
		error_and_die("%s: open: %s\n", src, strerror(errno));
	if (chdir(tmpdir) == -1)
		error_and_die("chdir(%s): %s\n", tmpdir, strerror(errno));
	out = popen("tar xzf -", "wb");
	if (!out)
		error_and_die("failed to open tar\n");
	lseek(ifd, htonl(rhdr.rootfs_l), SEEK_SET);
	tot=0;
	while( tot < htonl(rhdr.tar_l) ) {
		int r = htonl(rhdr.tar_l) - tot;
		if (r > BUFSIZ)
			r = BUFSIZ;
		if (read(ifd, buffer, r) != r)
			error_and_die("%s: failed to read %d bytes\n", src, r);
		if (fwrite(buffer, 1, r, out) != r)
			error_and_die("fwrite failed\n");
		tot += r;
	}
	pclose(out);
	close(ifd);
	if (stat("setup", &st) == 0)
		sstat = system("./setup");
	chdir("/");
	sprintf(rmcmd, "rm -rf %s", tmpdir);
	system(rmcmd);
	if (!WIFEXITED(sstat) || WEXITSTATUS(sstat))
		error_and_die("\n%s: script terminated abnormally\n", src);
	chdir(cwd);
}

int		main(int argc, char* argv[])
{
	struct stat							st;
	sigset_t								ss;
	int											i;

	if ( argc != 3 ) {
		error_and_die("Usage: %s <imagefile> <device>\n"
				" compiled in buffer size: %d\n",
				argv[0],BSIZE);
	}
	if ( stat(argv[2],&st) == -1 ) {
		error_and_die("destination file stat: %s\n",strerror(errno));
	}
	if ( stat(argv[1],&st) == -1 ) {
		error_and_die("source file stat: %s\n",strerror(errno));
	}

	/* validate the image */
	validate(argv[1]);
	printf("%s image version: %s\n", argv[1], version);

	/* extract the tar.gz */
	prerun(argv[1]);

	for(i = 5; i > 0; i--) {
		printf("\rImage will be written to %s in %d sec%s ... ", argv[2], i, i == 1 ? "" : "s");
		fflush(stdout);
		sleep(1);
	}
	printf("\n");

	/* disable signals */
	sigfillset(&ss);
	sigprocmask(SIG_SETMASK, &ss, NULL);
	
	/* write it */
	write_image(argv[1], argv[2]);

	printf(" done\n");
	printf("Syncing... ");
	fflush(stdout);
	sync();
	sleep(2);
	printf("done\n");
	fflush(stdout);
	printf("Killing INIT\n");
	fflush(stdout);
	sleep(1);
	kill(1,SIGTERM);

	return 0;
}

/*
 * vim: ts=2 sw=2
 */
