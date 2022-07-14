
import argparse
import os
import subprocess
import sys

# Future Proofing

def log(msg):
	print(msg)

def get_input(msg):
	return input(msg)

package_managers = ["apt-get","yum"]

# Packages

def get_packages(server_packages):
	s = 'packages.list'
	if server_packages:
		s = 'packages_server.list'
	f = open(s)
	packs_raw = f.read()
	f.close()
	packages = []
	for package in packs_raw.split('\n'):
		if not package.startswith('#')  and len(package)>0:
			packages.append(package)
	return packages

def install_package_manager():
	p = sys.platform
	if p == "darwin":
		install_ports()
	if p == "linux2" or p == "linux":
		check_package_managers()
	if p == "win32" or p == "win64":
		log("The F***?")

def install_packages(server_packages=False):
	install_package_manager()
	packages = get_packages(server_packages)
	log(str(packages))
	r = get_input("Would you like to install these packages? (y/n) ")
	if r == 'y':
		log('TODO: Fill in this function (install_packages)')
	elif r == 'n':
		log('Ok, as you wish')
	else:
		log('Err... ok ? (Unknown input)')

# Utils

def linkup(filename,destfilename=None):
	dstname = filename
	if destfilename is not None:
		dstname = destfilename
	src = '~/.dotfiles/'+filename
	dst = '~/.'+dstname
	cmd = 'ln -s ' +src + ' ' + dst
	os.system(cmd)

def linkup_folder(folder):	
	src = os.path.join(os.path.expanduser("~/.dotfiles/"),folder)
	dst = os.path.join(os.path.expanduser("~/"),".config")
	cmd = f"ln -s {src} {dst}"
	os.system(cmd)

def mkdir_if_needed(folder:str):
	dst = '~/.'+folder
	cmd = f'mkdir -p {dst}'
	os.system(cmd)

def has_app(app,arg=None): # app = "brew"
	try:
		if arg is None:
			subprocess.check_output(app)
		else:
			subprocess.check_output([app,arg])
		return True
	except subprocess.CalledProcessError:
		return True
	except:
		log("failed to open "+app)
	return False

def install_brew():
	if not has_app("brew"):
		brew_cmd='ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"'
		os.system(brew_cmd)
	else:
		log("skipping instalation of brew [Already Installed]")

def install_ports():
	if not has_app("port",'version'):
		port_cmd = "open http://www.macports.org/install.php"
		log("Please install ports manually.")
		os.system(port_cmd)
		get_input("Input anything to continue. ")
	else:
		log("skipping instalation of ports [Already Installed]")

def install_oh_my_zsh():
	if not os.path.exists(os.path.expanduser("~/.oh-my-zsh")):
		cmd = 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
		os.system(cmd)

def check_package_managers():
	for pm in package_managers:
		if has_app(pm):
			log("This system has " + pm + " installed.")
			return
	log("Warning, failed to identify the package manager for this system.")

parser = argparse.ArgumentParser()
parser.add_argument("--install","-i", help="Install default programs", action="store_true", default=False)
parser.add_argument("--install_server","-is", help="Install server programs", action="store_true", default=False)
parser.add_argument("--setup_zsh","-zsh", help="Setup zsh", action="store_true", default=False)
parser.add_argument("--linkup","-l", help="Link up (create symbolic links to config files)", action="store_true", default=False)
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
	linkup("bash_profile","bashrc")
	linkup("gitconfig")
	linkup("screenrc")
	linkup("tmux.conf")
	linkup("private/ssh.config","ssh/config")
	linkup("zshrc")

	linkup_folder("config/fish")
	linkup_folder("config/kitty")
	linkup_folder("config/alacritty")
	linkup_folder("config/qtile")
	linkup_folder("config/xfce4")
	linkup_folder("config/i3")
	linkup_folder("config/awesome")
	linkup_folder("config/flameshot")
	linkup_folder("config/picom")
	linkup_folder("config/variety")	
	linkup_folder("config/sway")	
	linkup_folder("config/nvim")
	linkup_folder("config/vim")
	linkup_folder("config/gtk-3.0")

