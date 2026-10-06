#!/bin/sh

if [ "$(hostname)" = "tsuki" ]; then
  {
    sleep 5 && \
      kanshi &
      librewolf &
      foot --server &
  } &
fi
