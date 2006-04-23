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
#include <fcntl.h>
#include <stdarg.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include <sys/reboot.h>

extern int		errno;

#ifndef BSIZE
#define BSIZE	16384
#endif

void	error_and_die(char* fmt,...)
{
	va_list	va;

	va_start(va,fmt);
	vprintf(fmt,va);
	va_end(va);
	exit(EXIT_FAILURE);
}

int		main(int argc, char* argv[])
{
	char*					buffer;
	unsigned long long		all;
	unsigned long long		done;
	int						percent;
	int						o_percent;
	struct stat				st;
	int						lastr;
	int						ifh,ofh;

	buffer=(char*)malloc(BSIZE);
	if ( !buffer ) {
		error_and_die("Cannot allocate %d bytes\n",BSIZE);
	}
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
	percent=0;
	o_percent=-1;
	all=st.st_size;
	done=0;
	ifh=open(argv[1],O_RDONLY);
	if ( ifh < 0 ) {
		error_and_die("open[source]: %s\n",strerror(errno));
	}
	ofh=open(argv[2],O_WRONLY);
	if ( ofh < 0 ) {
		error_and_die("open[dest]: %s\n",strerror(errno));
	}
	do {
		lastr=read(ifh,buffer,BSIZE);
		write(ofh,buffer,lastr);
		fsync(ofh);
		done+=lastr;
		percent=(int)((double)done*100.0/(double)all);
		if ( o_percent != percent ) {
			printf("\rWriting... [%3d%%]",percent);
			fflush(stdout);
			o_percent=percent;
		}
	} while( lastr == BSIZE );
	close(ofh);
	close(ifh);
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
