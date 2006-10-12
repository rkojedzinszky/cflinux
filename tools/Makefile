PROGS = mkcramfs write_helper rootfs-pack

all: $(PROGS)

mkcramfs: mkcramfs.c
	$(CC) -o $@ -Wall -O2 -I. $< -lz

write_helper: write_helper.c
	$(CC) -o $@ -Wall -Os -lssl $<

rootfs-pack: rootfs-pack.c rootfs.h
	$(CC) -o $@ -Wall -O2 -lssl rootfs-pack.c

distclean clean:
	rm -f $(PROGS)

.PHONY: all clean
