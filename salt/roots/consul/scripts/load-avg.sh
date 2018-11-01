#!/bin/bash
warn=$1
cores=`nproc`
load=`cat /proc/loadavg`
set -- $load
loadPercent=`awk '{print ($1/$2)*100}' <<< "$1 $cores"`
triggerWarning=`awk '{if($1>$2) print 1; else print 0;}' <<< "$loadPercent $warn"`
echo "cores: $cores, load: $load"
if [ $triggerWarning == "1" ]; then
 exit 1;
else
 exit 0
fi