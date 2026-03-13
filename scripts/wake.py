#!/usr/bin/env python3

import os
import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument("-n", "--name", help="The name of the computer")
parser.add_argument("-l", "--list", help="List known cameras", default=False, action="store_true")
args = parser.parse_args()

home = os.path.expanduser("~")
config = os.path.join(home, ".dotfiles", "private", "computers.json")
f = open(config)
d = json.loads(f.read())
f.close()


class Computer(object):

	def __init__(self, d: dict):
		self.name = d["name"]
		self.mac = d["mac"]


computers = list()
for pc in d:
	computers.append(Computer(pc))

if args.list:
	print("List of known cameras:")
	for computer in computers:
		print(f" - {computer.name} @ {computer.mac}")
	exit(0)

for computer in computers:
	if computer.name == args.name:
		os.system(f"wakeonlan {computer.mac}")
