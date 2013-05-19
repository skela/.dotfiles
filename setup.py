
import os
import sys
import subprocess

# Future Proofing

def log(msg):
    print msg

def get_input(msg):
    return raw_input(msg)

# Packages

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

def install_packages(packages):
    log('TODO: Fill in this function (install_packages)')

# Utils

def linkup(filename,destfilename=None):
    #os.system('ln -s ~/.dotfiles/bash_profile ~/.bash_profile')
    dstname = filename
    if destfilename is not None:
        dstname = destfilename
    src = '~/.dotfiles/'+filename
    dst = '~/.'+dstname
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
linkup('bash_profile','bashrc')
linkup('gitconfig')
linkup('screenrc')

# Packages
install_package_manager()
packages = get_packages()
log(str(packages))
r = get_input("Would you like to install these packages? (y/n)")
if r == 'y':
    install_packages(packages)
elif r == 'n':
    print 'Ok, as you wish'
else:
    print 'Err... ok ? (Unknown input)'
