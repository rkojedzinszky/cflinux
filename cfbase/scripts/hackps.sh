# -- * a PS hack for cflinux/busybox * --
# this script emulates some option of a real ps
# for programs (scripts) that need them
# currently -p and -C are implemented, other
# parameters are ignored
# mainly used by openswan
# krichy

ps ()
{
	case "$1" in
		-p)
			# check for a pid
			shift
			/bin/ps | awk "NR == 1 {print} \$1 == $1 { print; found++; exit } END { exit found == 0 }"
			;;
		-C)
			# check for a command
			shift
			/bin/ps | awk "NR == 1 {print} \$5 ~ /$1/ { print; found++; } END { exit found == 0 }"
			;;
		*)
			# default
			/bin/ps
			;;
	esac
}

# vim: ts=4 sw=4
