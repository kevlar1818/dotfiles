#!/bin/bash

# Note: to get the mouse coordinates in variables X and Y:
# eval $(xdotool getmouselocation --shell)

pkill -x dmenu

file="${1}.conkyrc"
class="conky_$1"

if [ $(pgrep -cf "$file") -gt 0 ]; then
    if [ -n "$(xdotool search --onlyvisible --class $class)" ]; then
        xdotool search --class conky windowunmap %@
    else
        xdotool search --class conky windowunmap %@
        xdotool search --class $class windowmap %1 windowraise
    fi
else
    source ~/.config/bspwm/panel/config
    screen_width=$(cat /tmp/xrandr.txt | grep -o 'current [0-9]\+' | awk '{print $2}')
    echo $screen_width

    xdotool search --class conky windowunmap %@
    if [ "$1" == 'cal' ]; then
        # centered, use alignment top_middle in conkyrc
        # NOTE: top_middle alone doesn't work with multiple screens of different pixel widths
        pos=$(((mon_offset + (mon_width - screen_width) / 2) * -1 ))
        echo $pos
        conky -x "$pos" -c ~/.config/bspwm/panel/conky/$file
    elif [ "$1" == 'weather' ]; then
        google-chrome-stable 'https://www.google.com/#q=weather' &
    else
        # right-aligned, use alignment top_right in conkyrc
        pos=$((screen_width - (mon_width + mon_offset - 14)))
        echo $pos
        conky -x "$pos" -c ~/.config/bspwm/panel/conky/$file
    fi
fi