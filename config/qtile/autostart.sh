#! /bin/bash

sh /home/skela/.screenlayout/layout.sh
variety &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom --experimental-backends &
nitrogen --restore &
thunar --daemon &
firefox-developer-edition &
thunderbird &
slack &
kitty &
xfce4-clipman &
1password &

