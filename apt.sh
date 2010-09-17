#!/bin/bash
#
# List of aptitude commands that will be issued when this script runs.

# First update, then upgrade
aptitude update
aptitude safe-upgrade

# Obvious packages
aptitude install gimp inkscape guake parcellite

# Programming Utilities
aptitude install spe

# Multimedia
aptitude install audacity arista-gtk vlc

