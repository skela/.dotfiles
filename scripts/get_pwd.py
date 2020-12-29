#!/usr/bin/env python3

import os
from os.path import expanduser
cwd = os.getcwd()
home = expanduser("~")

if not home.endswith("/"):
    home += "/"

if cwd.startswith(home):
    cwd = cwd.replace(home,"~/")

print(cwd)
