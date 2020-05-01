#!/bin/bash

BAR_ICON=""

get_total_updates() { UPDATES=$(packagectl upgradable-number 2> /dev/null); }

while true; do
    get_total_updates

    # when there are updates available
    # every 10 seconds another check for updates is done
    while (( UPDATES > 0 )); do
        echo "$BAR_ICON $UPDATES"
        sleep 10
        get_total_updates
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every 30 min for new updates
    while (( UPDATES == 0 )); do
        echo "$BAR_ICON $UPDATES"
        sleep 1800
        get_total_updates
    done
done
