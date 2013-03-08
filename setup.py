
import os
import sys
import subprocess

def log(msg):
    print msg

def get_packages():
    f = open('packages.list')
    packs_raw = f.read()
    f.close()
    packages = []
    for package in packs_raw.split('\n'):
        if not package.startswith('#')  and len(package)>0: 
            packages.append(package)
    return packages

def install_package_manager():
    if sys.platform == "darwin":
        install_brew()

def linkup(filename):
    #os.system('ln -s ~/.dotfiles/bash_profile ~/.bash_profile')
    src = '~/.dotfiles/'+filename
    dst = '~/.'+filename
    cmd = 'ln -s ' +src + ' ' + dst
    os.system(cmd)

def has_app(app): # app = "brew"
    try: 
        ret = subprocess.check_output(app)
        return True
    except subprocess.CalledProcessError,e:
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

# Link up files
linkup('bash_profile')
linkup('gitconfig')

install_package_manager()

#packages = get_packages()
#print packages
