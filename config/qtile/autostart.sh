#! /bin/bash
sh /home/skela/.screenlayout/layout.sh
variety &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

#picom --experimental-backends &
# picom &
picom -b --config ~/.config/picom/picom-corners.conf &
# picom -b --no-ewmh-fullscreen --config ~/.config/picom/picom-corners.conf &

nitrogen --restore &
thunar --daemon &
dunst &
# thunderbird &
# slack &
# wezterm &
kitty &
#xfce4-clipman &
#clipse -listen
greenclip daemon &
1password &

if [ "$(hostname)" == "aurora" ]; then
	streamdeck -n &
fi
