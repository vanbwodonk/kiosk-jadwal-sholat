#!/bin/bash
export DISPLAY=:0
KIOSK_URL="index.html"

unclutter -idle 0.1 -grab -root &

xrandr --auto
chromium \
  --noerrdialogs \
  --no-memcheck \
  --no-first-run \
  --start-maximized \
  --disable \
  --disable-translate \
  --disable-infobars \
  --disable-suggestions-service \
  --disable-save-password-bubble \
  --disable-session-crashed-bubble \
  --incognito \
  --kiosk $KIOSK_URL

