#!/usr/bin/env fish

# Monitor name to wait for
set trigger_monitor DP-3

set scale_monitor eDP-1

# Scaling factor to set
set scaling_factor 1.25

set last_monitor_in DP-3

set old_scale 1

while true
    # Check if the monitor is connected
    set monitor_in (swaymsg -t get_outputs | jq -r ".[] | select(.name==\"$trigger_monitor\") | .name")
    echo "$last_monitor_in , $monitor_in"
    # If the monitor was just connected
    if test "$monitor_in" = "$trigger_monitor" -a "$last_monitor_in" = ""
        # Get the old scaling factor
        set old_scale (swaymsg -t get_outputs | jq -r ".[] | select(.name==\"$scale_monitor\") | .scale")
        # Set scaling factor
        swaymsg output "$scale_monitor" scale "$scaling_factor"
        echo "plugged in, set scale"
    end
    # If the monitor was just disconnected
    if test "$monitor_in" = "" -a "$last_monitor_in" != ""
        # Set scaling factor
        swaymsg output "$scale_monitor" scale $old_scale
        echo "unplugged reset scale"
    end

    echo "$last_monitor_in , $monitor_in"
    set last_monitor_in $monitor_in

    sleep 1
end
