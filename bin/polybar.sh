#!/bin/sh

killall -q polybar

monitors=$(xrandr -q | grep -E "[^dis]connected" | awk '{print $1}')

for mon in ${monitors}; do
	MONITOR=${mon} polybar desktop & disown
done
