import argparse
import os
import subprocess
import sys
import json
import re


class FolderLink(object):

	def __init__(self, src: str):
		self.src = src


class FileLink(object):

	def __init__(self, src: str):
		self.src = src


folder_links = [
	FolderLink("config/fish"),
	FolderLink("config/ghostty"),
	FolderLink("config/kitty"),
	FolderLink("config/alacritty"),
	FolderLink("config/wezterm"),
	FolderLink("config/qtile"),
	FolderLink("config/hypr"),
	FolderLink("config/hypr/swaylock"),
	FolderLink("config/xfce4"),
	FolderLink("config/i3"),
	FolderLink("config/awesome"),
	FolderLink("config/tmux"),
	FolderLink("config/yazi"),
	FolderLink("config/flameshot"),
	FolderLink("config/picom"),
	FolderLink("config/variety"),
	FolderLink("config/sway"),
	FolderLink("config/nvim"),
	FolderLink("config/vim"),
	FolderLink("config/gtk-3.0"),
	FolderLink("config/clipse"),
	FolderLink("config/paru"),
	FolderLink("config/rustfmt"),
	FolderLink("config/rofi"),
	FolderLink("config/posting"),
	FolderLink("config/pop-shell"),
	FolderLink("config/polybar"),
	FolderLink("config/yazi"),
]

file_links = [
	FileLink("config/greenclip.toml"),
	FileLink("config/electron-flags.conf"),
	FileLink("config/albert.conf"),
]


def log(msg):
	print(msg)


def get_input(msg):
	return input(msg)


package_managers = ["apt-get", "apt", "yum", "yay", "paru"]


def get_packages(server_packages: bool):
	s = "packages.jsonc"
	f = open(s)
	packs_raw = f.read()
	f.close()

	packs_raw = re.sub(r'//.*?$', '', packs_raw, flags=re.MULTILINE)
	packs_raw = re.sub(r'/\*.*?\*/', '', packs_raw, flags=re.DOTALL)

	packages = []
	ar = json.loads(packs_raw)
	for package in ar:
		if server_packages:
			if "tags" in package and "server" in package["tags"]:
				packages.append(package["name"])
		else:
			packages.append(package["name"])
	return packages


def install_package_manager():
	p = sys.platform
	if p == "darwin":
		install_brew()
	if p == "linux2" or p == "linux":
		check_package_managers()
	if p == "win32" or p == "win64":
		log("The F***?")


def install_packages(server_packages=False):
	install_package_manager()
	packages = get_packages(server_packages)
	log(str(packages))
	r = get_input("Would you like to install these packages? (y/n) ")
	if r == "y" or r == "Y":
		log("TODO: Fill in this function (install_packages)")
	elif r == "n":
		log("Ok, as you wish")
	else:
		log("Err... ok ? (Unknown input)")


# Utils


def linkup(filename, destfilename=None):
	dstname = filename
	if destfilename is not None:
		dstname = destfilename
	src = "~/.dotfiles/" + filename
	dst = "~/." + dstname
	cmd = "ln -s " + src + " " + dst
	os.system(cmd)


def linkup_folder(folder: FolderLink):
	src = os.path.join(os.path.expanduser("~/.dotfiles/"), folder.src)
	dst = os.path.join(os.path.expanduser("~/"), ".config")

	cmd = f"ln -s {src} {dst}"
	os.system(cmd)


def linkup_file(file: FileLink):
	src = os.path.join(os.path.expanduser("~/.dotfiles/"), file.src)
	dst = os.path.join(os.path.expanduser("~/"), ".config")

	cmd = f"ln -s {src} {dst}"
	os.system(cmd)


def mkdir_if_needed(folder: str):
	dst = "~/." + folder
	cmd = f"mkdir -p {dst}"
	os.system(cmd)


def has_app(app, arg=None):    # app = "brew"
	try:
		if arg is None:
			subprocess.check_output(app)
		else:
			subprocess.check_output([app, arg])
		return True
	except subprocess.CalledProcessError:
		return True
	except Exception as _:
		pass
	return False


def install_brew():
	if not has_app("brew"):
		brew_cmd = 'ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"'
		os.system(brew_cmd)
	else:
		log("skipping instalation of brew [Already Installed]")


def install_oh_my_zsh():
	if not os.path.exists(os.path.expanduser("~/.oh-my-zsh")):
		cmd = 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
		os.system(cmd)


def check_package_managers():
	log("Checking package managers...")
	for pm in package_managers:
		if has_app(pm):
			log("This system has " + pm + " installed.")
			return
	log("Warning, failed to identify the package manager for this system.")


parser = argparse.ArgumentParser()
parser.add_argument("--install", "-i", help="Install default programs", action="store_true", default=False)
parser.add_argument("--install_server", "-is", help="Install server programs", action="store_true", default=False)
parser.add_argument("--setup_zsh", "-zsh", help="Setup zsh", action="store_true", default=False)
parser.add_argument("--linkup", "-l", help="Link up (create symbolic links to config files)", action="store_true", default=False)
args = parser.parse_args()

if args.setup_zsh:
	install_oh_my_zsh()

if args.install:
	install_packages()

if args.install_server:
	install_packages(server_packages=True)

if args.linkup:
	linkup("aliases")
	linkup("bash_profile")
	linkup("bash_profile", "bashrc")
	linkup("gitconfig")
	linkup("private/ssh.config", "ssh/config")

	for link in folder_links:
		linkup_folder(link)

	for link in file_links:
		linkup_file(link)
