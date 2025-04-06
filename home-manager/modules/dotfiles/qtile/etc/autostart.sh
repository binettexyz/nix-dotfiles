#!/bin/sh

if [ "$(hostname)" = "seiryu" ]; then
    (
      sleep 5 &&
      wlr-randr --output HDMI-A-1 --pos 0,0    --mode 1920x1080@179.981995 \
                --output HDMI-A-2 --pos 1920,0 --mode 3840x2160@120 --off
    )
    /etc/profiles/per-user/binette/bin/emacs --daemon &
fi
