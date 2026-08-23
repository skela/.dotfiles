#!/bin/bash
# Launcher script to apply custom Qt stylesheet

# Don't use any platform theme so our stylesheet can work
unset QT_QPA_PLATFORMTHEME
unset QT_STYLE_OVERRIDE

exec quickshell -p "$HOME/.dotfiles/config/quickshell/skela-bar"
