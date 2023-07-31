#! /bin/bash

sh /home/skela/.screenlayout/layout.sh
variety &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom --experimental-backends &
nitrogen --restore &
thunar --daemon &
thunderbird &
slack &
wezterm &
xfce4-clipman &
1password &
albert &

