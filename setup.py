
import os
import sys
import subprocess

# Future Proofing

def log(msg):
    print msg

def get_input(msg):
    return raw_input(msg)

package_managers = ["apt-get","yum"]

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
    p = sys.platform
    if p == "darwin":
        install_ports()
    if p == "linux2" or p == "linux":
        check_package_managers()
    if p == "win32" or p == "win64":
        log("The F***?")

def install_packages():
    install_package_manager()
    packages = get_packages()
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

def install_ports():
    if not has_app("port"):
        port_cmd = 'open http://www.macports.org/install.php'
        log("Please install ports manually.")
        os.system(port_cmd)
        get_input("Input anything to continue. ")
    else:
        log("skipping instalation of ports [Already Installed]")

def check_package_managers():
    for pm in package_managers:
        if has_app(pm):
            log("This system has " + pm + " installed.")
            return
    log("Warning, failed to identify the package manager for this system.")

# Check arguments
should_install_packages = 'install' in sys.argv

# Link up files
linkup('bash_profile')
linkup('bash_profile','bashrc')
linkup('gitconfig')
linkup('screenrc')
linkup('vimrc')
linkup('vim')

# Packages
if should_install_packages:
    install_packages()
