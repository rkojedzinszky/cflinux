CC = gcc
CFLAGS = -W -Wall -O2 -g
CPPFLAGS = -I$(KERNEL_INCLUDE)
LDLIBS = -lz
PROGS = mkcramfs

all: $(PROGS)

distclean clean:
	rm -f $(PROGS)

.PHONY: all clean
