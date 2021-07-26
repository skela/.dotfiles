import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("--device","-d", help="Name of device")
args = parser.parse_args()

p  = os.path.join(os.path.expanduser('~'),'code','home')
os.chdir(p)

os.system(f'python3 main.py -xc -c toggle -d "{args.device}"')

# "Office Dimmer"

#"Hallway Lights"
