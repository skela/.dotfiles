#!/usr/bin/env python3

import os
import argparse
import json
import subprocess
import threading

parser = argparse.ArgumentParser()
parser.add_argument('-n', '--names', help="The name(s) of the camera(s) (comma separated if multiple)")
parser.add_argument('-i', '--ip', help="An ip address")
args = parser.parse_args()

class Camera(object):

	def __init__(self,d:dict):
		self.name = d["name"]
		self.src = d["src"]

class CameraCollection(object):

	def __init__(self,d:dict):
		self.name = d["name"]
		self.cameras = d["cameras"]

class Cameras(object):

	def __init__(self):

		home = os.path.expanduser("~")
		config = os.path.join(home,".config","cameras.json")
		f = open(config)
		d = json.loads(f.read())
		f.close()
		
		cams = d["cameras"]
		cameras = list()
		for cam in cams:
			cameras.append(Camera(cam))
		self.cameras = cameras

		aliases = list()
		ali = d["aliases"]
		for a in ali:
			alias = CameraCollection(a)
			aliases.append(alias)
		self.aliases = aliases

	def get_camera(self,name:str) -> Camera:
		for cam in self.cameras:
			if cam.name == name:
				return cam
		return None

	def get_collection(self,name:str) -> list[Camera]:
		for alias in self.aliases:
			if alias.name == name:
				cameras = list()
				for cam in alias.cameras:
					camera = self.get_camera(cam)
					if camera is not None:
						cameras.append(camera)
				if len(cameras) > 0:
					return cameras
		return None

names = args.names
chosen_cameras = list()

if names is not None:
	names = names.split(",")
else:
	names = []

cameras = Cameras()
for name in names:	
	camera = cameras.get_camera(name)
	if camera is not None:
		chosen_cameras.append(camera)
	else:
		collection = cameras.get_collection(name)
		if collection is not None:
			chosen_cameras.extend(collection)

if args.ip is not None:
	chosen_cameras.append(Camera({"name":"temp","src":f"rtsp://{args.ip}/12:554"}))

if len(chosen_cameras) == 0:
	exit(f"No cameras found with the name {name}")	

processes = list()
for camera in chosen_cameras:
	cmd = f"ffplay -rtsp_transport tcp -i {camera.src}"
	p = subprocess.Popen([cmd],shell=True)
	processes.append(p)

try:
	print('Press Ctrl+C to exit')
	for process in processes:
		process.wait()
except KeyboardInterrupt:
	for process in processes:
		process.kill()
