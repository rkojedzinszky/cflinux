#!/bin/sh

if=`grep -H "^User-Name $1$" /var/run/radattr.* 2>/dev/null | \
	sed "s/^.*radattr\.//;s/:User-Name $1$//"`
[ -z "$if" ] && exit 0

/etc/ppp/set_qos.sh "$if" "$2" "$2"
