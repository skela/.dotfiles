import os
import argparse

def scan():
	cmd = "nmcli device wifi"
	os.system(cmd)

def connect(ssid:str):
	cmd = f'sudo nmcli --ask dev wifi connect "{ssid}"'
	os.system(cmd)

parser = argparse.ArgumentParser()
parser.add_argument("--scan","-s",help="Scan for wifi networks (wifi-scan)",action="store_true",default=False)
parser.add_argument("--connect","-c", help="SSID of wifi network name that you want to connect to (wifi-connect)")
args = parser.parse_args()

if args.scan:
	scan()

ssid = args.connect
if ssid is not None:
	connect(ssid)

