#! /bin/bash

sh /home/skela/.screenlayout/layout.sh
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom --experimental-backends &
nitrogen --restore &
