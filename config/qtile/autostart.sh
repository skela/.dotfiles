#! /bin/bash

sh /home/skela/.screenlayout/layout.sh
variety &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom --experimental-backends &
nitrogen --restore &
(conky -c $HOME/.config/qtile/conkyrc) &

firefox-developer-edition &
thunderbird &
slack &
alacritty &
