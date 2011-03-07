HOSTCC = cc

PROGS = mkcramfs write_helper rootfs-pack

all: $(PROGS)

mkcramfs: mkcramfs.c
	$(HOSTCC) -o $@ -Wall -O2 -I. $< -lz

write_helper: write_helper.c
	$(CC) -o $@ -Wall -Os -lcrypto $<

rootfs-pack: rootfs-pack.c rootfs.h
	$(HOSTCC) -o $@ -Wall -O2 rootfs-pack.c -lcrypto

distclean clean:
	rm -f $(PROGS)

.PHONY: all clean
