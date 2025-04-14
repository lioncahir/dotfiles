#!/bin/bash

if pgrep -f "foot --server" > /dev/null
then
    footclient $1 "$2"
elif [ $TERM = "xterm-kitty" ] 
then
    kitty $1 "$2"
else
    $TERM $1 "$2"
fi
