#!/bin/python3

import os
import subprocess
import socket


def change_to_norwegian():
	os.system("setxkbmap no,gb")


def change_to_british():
	os.system("setxkbmap gb,no")


ret = subprocess.check_output("setxkbmap -query |grep layout", stderr=subprocess.STDOUT, shell=True)
ret = ret.decode("utf-8")
index = ret.find(":") + 1
ret = ret[index:len(ret) - 1].strip()

layout = ret.split(",")[0]

if layout == "no":
	change_to_british()
elif layout == "gb":
	change_to_norwegian()

machine = socket.gethostname()

# hyprctl devices to list devices
# aurora running hyprland
if machine == "aurora":
	os.system("hyprctl switchxkblayout logitech-gaming-keyboard-g810 next")
if machine == "dark":
	os.system("hyprctl switchxkblayout primax-hp-wired-desktop-320k-keyboard next")
