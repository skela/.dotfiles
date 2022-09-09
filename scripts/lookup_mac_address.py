import os
import argparse
import subprocess
import json

parser = argparse.ArgumentParser()
parser.add_argument("--ip","-i", help="IP Address to resolve the MAC address for")
args = parser.parse_args()

ip : str = args.ip

if ip is None:
	ip = input("Enter ip address to locate MAC address\n>")

os.system(f"ping {ip} -c 4")

code, res = subprocess.getstatusoutput(f"arp -n {ip} |jc --arp")

if code == 0:
	ar = json.loads(res)
	mac = ar[0]["hwaddress"]
	print("MAC address:")
	print(mac)
else:
	print("Error failed to lookup MAC address")

