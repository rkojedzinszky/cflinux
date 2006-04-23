PROGS = mkcramfs write_helper

all: $(PROGS)

mkcramfs: mkcramfs.c
	$(CC) -o $@ -Wall -O2 -I$(KERNEL_INCLUDE) $< -lz

write_helper: write_helper.c
	$(CC) -o $@ -Wall -Os -lssl $<

distclean clean:
	rm -f $(PROGS)

.PHONY: all clean
