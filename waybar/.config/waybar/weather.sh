#!/usr/bin/env bash

text=$(curl wttr.in?format="%c%t")
tooltip=$(curl wttr.in?format="%l")

echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
