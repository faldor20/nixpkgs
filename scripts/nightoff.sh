#!/bin/sh
while true; do
   hour=$(date '+%H')
   echo $hour
   min=$(date '+%M')
   #1=monday 7=sunday
   #weekday= $(date "+%u")
        if [ $hour -gt 21 ] # shutdown at 10 oclock
        then
            shutdown 0
        fi
   sleep 600
done
