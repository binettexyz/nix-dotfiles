#!/bin/sh

VALUE=15

case "$1" in
	up)   doas light -A $VALUE;;
	down) doas light -U $VALUE;;
esac
