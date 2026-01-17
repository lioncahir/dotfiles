#!/usr/bin/env bash

if pgrep -f "foot --server" > /dev/null
then
    (command -v waitwinch &> /dev/null) && terminal="footclient waitwinch" || terminal="footclient"
    exec $terminal $1 "$2"
elif [ $TERM = "xterm-kitty" ] 
then
    exec kitty $1 "$2"
else
    exec $TERM $1 "$2"
fi
