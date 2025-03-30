#!/bin/sh

VALUE=5

case "$1" in
	mute) pamixer -t;;
	up)   pamixer --allow-boost -i $VALUE;;
	down) pamixer --allow-boost -d $VALUE;;
esac
