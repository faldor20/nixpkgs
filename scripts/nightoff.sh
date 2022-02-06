#!/bin/sh
while true; do
   hour=$(date '+%H')
   echo $hour
   min=$(date '+%M')
   #1=monday 7=sunday
   #weekday= $(date "+%u")
        if [ $hour -gt 19 ] # shutdown at 8 oclock
        then
            shutdown 0
        fi
   sleep 600
done
