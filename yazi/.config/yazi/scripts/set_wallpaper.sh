#!/usr/bin/env bash

case $XDG_SESSION_DESKTOP in
    "sway")     
        ln -sf "$1" ~/.wallpaper
        swaymsg output "*" background ~/.wallpaper fill ;;
    "niri")
        ln -sf "$1" ~/.wallpaper
        PID=$(pidof swaybg)
        niri msg action spawn-sh -- "swaybg -m fill -i ~/.wallpaper" 
        sleep 1
        kill "$PID" 2>/dev/null ;;
    "i3")       
        feh --bg-scale $1 ;;
    *)  
        echo "Can't do" ;;
esac
