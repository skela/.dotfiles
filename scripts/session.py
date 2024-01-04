import os
import argparse
import subprocess

valid_sessions = [
	"work",
	"def"
]

parser = argparse.ArgumentParser()
parser.add_argument("name", help=f"Name of session, valid choices are: {', '.join(valid_sessions)}", default=None)
args = parser.parse_args()

class Wezterm(object):

	def __init__(self):
		pass

	def execute(self,cmd):
		_,output = subprocess.getstatusoutput(cmd)
		return output

	def list_workspaces(self):
		_,output = self.execute("wezterm cli list-clients")
		lines = output.split("\n")
		lines.pop(0)
		workspaces = []
		for line in lines:
			cols = line.split(" ")
			workspaces.append(cols[5])
		return workspaces

	def does_workspace_exist(self,workspace:str) -> bool:
		res = self.execute("wezterm cli list-clients | awk '{ print $6 }'")
		lines = res.split("\n")
		lines.pop(0)
		for line in lines:
			if workspace == line:
				return True
		return False

	def create_workspace(self,workspace:str,cwd:str):
		self.execute(f'wezterm cli spawn --new-window --cwd "{cwd}" --workspace "{workspace}"')

	def rename_workspace(self,workspace:str):
		self.execute(f"wezterm cli rename-workspace {workspace}")

	def create_tab(self,tab:str,path:str):
		if not os.path.exists(os.path.expanduser(path)):
			return
		tab_id = self.execute(f"wezterm cli spawn --cwd {path} --")
		self.execute(f"wezterm cli set-tab-title --tab-id {tab_id} {tab}")

mux = Wezterm()
if args.name == "work":
	# print(f"work session : workspaces {mux.list_workspaces()}")
	exists = mux.does_workspace_exist(args.name)
	if exists:
		print(f"Workspace \"{args.name}\" already exists")
	else:
		mux.rename_workspace(args.name)
		mux.create_tab("kit","~/code/easee/kit")
		mux.create_tab("usr","~/code/easee/users")
		mux.create_tab("ins","~/code/easee/installers")
		mux.create_tab("api","~/code/easee/api")

elif args.name == "def":
	exists = mux.does_workspace_exist(args.name)
	if exists:
		print(f"Workspace \"{args.name}\" already exists")
	else:
		mux.rename_workspace("def")
		mux.create_tab("df","~/.dotfiles")
		mux.create_tab("services","/mnt/australis/services")
		mux.create_tab("blink","~/code/blink")
		mux.create_tab("rod","~/code/r") 

else:
	print(f"Unknown session ({args.name})")
