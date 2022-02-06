#!/bin/sh
logpath=~/Notes/Pomodoro/pomodoro-log-$(date "+%m-%d").md;
echo -e "\n## During $(date "+%R") I:   \n \n## For my next pomorodo I will:\n" >> $logpath;
#kitty -o allow_remote_control=yes nvim $logpath;
ghostwriter $logpath
done
