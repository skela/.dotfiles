#! /bin/bash
sh /home/skela/.screenlayout/layout.sh
variety &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#picom --experimental-backends &
# picom &
picom -b --config ~/.config/picom/picom-corners.conf &
nitrogen --restore &
thunar --daemon &
dunst &
# thunderbird &
# slack &
# wezterm &
kitty &
xfce4-clipman &
1password &
