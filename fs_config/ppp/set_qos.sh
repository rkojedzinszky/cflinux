#!/bin/sh

if="$1"
downstream="$2"
upstream="$3"

[ -z "$downstream" -o "$downstream" = 0 ] && downstream=768
[ -z "$upstream" -o "$upstream" = 0 ] && upstream=768
db=`expr $downstream \* 10`
ub=`expr $upstream \* 20`
[ "$db" -lt 1500 ] && db=1500
[ "$ub" -lt 1500 ] && ub=1500

tc qdisc del dev "$if" root 2>/dev/null
tc qdisc del dev "$if" ingress 2>/dev/null

if [ "$downstream" != 0 ]; then
	tc qdisc add dev $if root tbf limit 5000 burst ${db} rate ${downstream}kbit
fi
if [ "$upstream" != 0 ]; then
	tc qdisc add dev $if handle ffff: ingress
	tc filter add dev $if parent ffff: prio 50 protocol ip \
		u32 \
		match ip src 0.0.0.0/0 \
		police rate ${upstream}kbit burst $ub drop flowid :1
fi
