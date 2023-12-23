import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-n", "--name", help="Name", default=None)
args = parser.parse_args()

print(f"name is {args.name}")
