# Common functions related to the configuration
#

if [ -z "$__system_device" ]; then
	if ! [ -f "/var/run/__system_device" ] ; then
		echo "Cannot determine the system device!"
		echo "This is an error, which should not happen."
		echo "Exiting."
		exit 1
	fi
	__system_device=$(cat /var/run/__system_device)
fi

conf_dev1=${__system_device}1	# first configuration space
conf_dev2=${__system_device}2	# second configuration space
conf_size=2047			# in k

# the checksum and the timestamp's offset in bytes
# time stamp is in 11 digits, and contains the seconds from Epoch
time_offset=`expr $conf_size \* 1024`
time_length=11
md5_offset=`expr $time_offset + $time_length`

get_timestamp () {
	dd if=$1 skip=$time_offset bs=1 count=$time_length 2>/dev/null
}

is_valid () {
	sum=`dd if=$1 bs=1k count=$conf_size 2>/dev/null | md5sum | dd bs=1 count=32 2>/dev/null`
	saved_sum=`dd if=$1 bs=1 skip=$md5_offset count=32 2>/dev/null`
	[ "$sum" = "$saved_sum" ]
}

other_dev () {
	if [ "$1" = "$conf_dev1" ]; then
		echo "$conf_dev2"
	else
		echo "$conf_dev1"
	fi
}

get_fresh_and_valid () {
	stamp1=`get_timestamp $conf_dev1`
	stamp2=`get_timestamp $conf_dev2`

	if [ "$stamp1" -ge "$stamp2" ] >/dev/null 2>&1 ; then
		dev=$conf_dev1
	else
		dev=$conf_dev2
	fi
	
	if is_valid $dev ; then
		echo $dev
		return
	fi
	dev=`other_dev $dev`
	if is_valid $dev ; then
		echo $dev
		return
	fi
	return
}
