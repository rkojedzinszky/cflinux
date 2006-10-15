
SCRIPTS = setup $(wildcard *.sh)

all: setup.tgz

setup.tgz: $(SCRIPTS)
	tar czf $@ $(SCRIPTS)

clean:
	rm -f setup.tgz

.PHONY: all clean
