#!/bin/bash
#
# This script is completly based on the KCS article https://access.redhat.com/solutions/5343671

# Resolution in seconds
RESOLUTION=${1:-5} 
# Duration in seconds (or whatever is acceptable as an argument to "sleep")
DURATION=${2:-10}

BASE_DIR=/run/collect-metrics
now=$(date +%Y_%m_%d_%H)
rm -rf $BASE_DIR/archives/*

echo "Gathering metrics ..."
echo "Resolution: $RESOLUTION"
echo "Duration  : $DURATION"

if [ ! -d "$BASE_DIR/$HOSTNAME-metrics_$now" ];
then
  mkdir $BASE_DIR/$HOSTNAME-metrics_$now
fi
rm -Rf $BASE_DIR/$HOSTNAME-metrics_$now/*
pidstat -p ALL -T ALL -I -l -r  -t  -u -w ${RESOLUTION} > "$BASE_DIR/$HOSTNAME-metrics_$now/pidstat.txt" &
PIDSTAT=$!
sar -A ${RESOLUTION} > "$BASE_DIR/$HOSTNAME-metrics_$now/sar.txt" &
SAR=$!
bash -c "while true; do date ; ps aux | sort -nrk 3,3 | head -n 20 ; sleep ${RESOLUTION} ; done" > "$BASE_DIR/$HOSTNAME-metrics_$now/ps.txt" &
PS=$!
bash -c "while true ; do date ; free -m ; sleep ${RESOLUTION} ; done" > "$BASE_DIR/$HOSTNAME-metrics_$now/free.txt" &
FREE=$!
bash -c "while true ; do date ; cat /proc/softirqs; sleep ${RESOLUTION}; done" > "$BASE_DIR/$HOSTNAME-metrics_$now/softirqs.txt" &
SOFTIRQS=$!
bash -c "while true ; do date ; cat /proc/interrupts; sleep ${RESOLUTION}; done" > "$BASE_DIR/$HOSTNAME-metrics_$now/interrupts.txt" &
INTERRUPTS=$!
iotop -Pobt > "$BASE_DIR/$HOSTNAME-metrics_$now/iotop.txt" &
IOTOP=$!
#echo "Metrics gathering started. Please wait for completion..."
sleep "${DURATION}"
kill $PIDSTAT
kill $SAR
kill $PS
kill $FREE
kill $SOFTIRQS
kill $INTERRUPTS
kill $IOTOP

tar -czf $BASE_DIR/archives/$HOSTNAME-metrics_$now.tar.gz  -C / run/collect-metrics/$HOSTNAME-metrics_$now/

status=$?
[ $status -eq 0 ] && echo "Metrics collection completed" || echo "Metrics collection failed"
