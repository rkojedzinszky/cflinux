#!/bin/sh

echo -n "Erasing config filesystem... "
dd if=/dev/zero of=/dev/mtdblock0 bs=8k seek=448 count=1 conv=notrunc >/dev/null 2>&1
echo "done"
