#!/bin/sh

. /usr/lib/cfmaint/common.sh

echo "This will erase the two configuration partitions."
for i in 5 4 3 2 1 ; do
	echo -ne "\rYou have $i seconds to abort"
	sleep 1
done
echo -ne "\nErasing "
dd if=/dev/zero of=$conf_dev1 bs=1k >/dev/null 2>&1
dd if=/dev/zero of=$conf_dev2 bs=1k >/dev/null 2>&1
echo "done"
