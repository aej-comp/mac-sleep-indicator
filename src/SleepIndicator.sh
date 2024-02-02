#!/bin/bash

PNAME=$(basename $0)
PSUBNAME="log stream --predicate"

KEYWORD_SLEEP="kIOMessageSystemWillSleep"
KEYWORD_WAKE="kIOMessageSystemHasPoweredOn"

PROCESS_MONITOR="powerd"

CRTL_WORD_SLEEP="b"
CRTL_WORD_WAKE="a"


# function to check if script is already running (args: $1 pname, $2 psubname)
check_running(){

	# get current user
	USER=$(whoami)

	# get PIDS of PNAME and PSUBNAME
	PIDS=$(pgrep -u $USER -f $1)
	PIDS2=$(pgrep -u $USER -f "$2")

	# combine PIDS
	PIDS+=" "
	PIDS+=$PIDS2
	

	for PID in $PIDS; do
		kill -9 $PID
	done
}


# function to find correct device
find_device(){

	# find all /dev/cu.usbmodem* devices (if any)
	if [ -e /dev/cu.usbmodem* ]; then
		DEVICES=$(ls /dev/cu.usbmodem*)
	fi

	# loop through devices
	for DEVICE in $DEVICES; do

		# probe device if correct device
		echo "i" >> $DEVICE &
		RESPONSE=$(head -c3 < $DEVICE)

		if [ $RESPONSE == "sil" ]; then
			echo $DEVICE
			break
		fi
 
	done

}


# function to monitor sleep or wake events (args: $1 keyword, $2 process, $3 crtl word, $4 sil device)
monitor_sleep_wake(){

	PREDICATE="eventMessage contains \"$1\" AND processImagePath contains \"$2\""

	log stream --predicate "$PREDICATE" |while read line; do

		# skip first line 
		if echo $line  |grep -q "Filtering"; then
			continue
		fi

		# sleep or wake trigger
		if echo $line |grep -q $1; then
			echo $3 >> $4
		fi   

	done

}

# check if script is already running
check_running $PNAME "$PSUBNAME"

# print date
echo "$(date "+%Y-%m-%d %H:%M:%S")"
echo "-----------------------------"

# find SIL device
SIL_DEVICE=$(find_device)

# print device info
if [ -z "$SIL_DEVICE" ]; then
	echo "Error: Sleep Indicator Dongle not detected"
	echo "Error: Plug in Dongle and restart app"
	exit 0
else
	echo "Sleep Indicator Dongle detected" $SIL_DEVICE
fi

# start monitoring sleep
monitor_sleep_wake $KEYWORD_SLEEP $PROCESS_MONITOR $CRTL_WORD_SLEEP $SIL_DEVICE &

# start monitoring wake
monitor_sleep_wake $KEYWORD_WAKE $PROCESS_MONITOR $CRTL_WORD_WAKE $SIL_DEVICE &

# print success
echo "Initialization successful"
echo "Keep app running in background"

wait

