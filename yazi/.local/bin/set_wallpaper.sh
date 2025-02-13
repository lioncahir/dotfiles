#!/bin/bash

case $XDG_SESSION_DESKTOP in
    "sway")     ln -sf "$1" ~/.wallpaper
                swaymsg output "*" background ~/.wallpaper fill ;;
    "i3")       feh --bg-scale $1 ;;
    *)          echo "Can't do" $1 ;;
esac
