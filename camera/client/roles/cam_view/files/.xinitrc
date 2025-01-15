#!/bin/sh
set -eux

# disable power saving, screen blanking, etc...
xset -dpms
xset s off
xset s noblank

# hide mouse pointer
unclutter &

# run window manager
matchbox-window-manager \
  -use_titlebar no \
  -use_cursor no \
  -use_desktop_mode plain \
  &

# start the app
cd /opt/cam_view
./run 2>&1 | logger -s -t "cam_view"
