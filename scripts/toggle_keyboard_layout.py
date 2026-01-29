#!/bin/python3

import os
import subprocess
import socket
from typing import Optional


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

# for machines running hyprland - hyprctl devices to list devices

keyboard: Optional[str] = None
if machine == "aurora":
	keyboard = "logitech-gaming-keyboard-g810"
elif machine == "dark":
	keyboard = "keychron--keychron-link--keyboard"

if keyboard is not None:
	os.system(f"hyprctl switchxkblayout {keyboard} next")
