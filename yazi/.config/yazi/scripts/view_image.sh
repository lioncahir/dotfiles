#!/bin/bash

case $XDG_SESSION_DESKTOP in
    sway|niri|mango)     swayimg "$1" . ;;
    "i3")                feh --start-at "$1" ;;
    *)                   xdg-open "$1" ;;
esac
