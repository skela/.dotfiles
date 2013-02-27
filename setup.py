
import os
import sys

def get_packages():
    f = open('packages.list')
    packs_raw = f.read()
    f.close()
    packages = []
    for package in packs_raw.split('\n'):
        if not package.startswith('#')  and len(package)>0: 
            packages.append(package)
    return packages

# Link up bash_profile
os.system('ln -s ~/.dotfiles/bash_profile ~/.bash_profile')

# TODO: Use Brew for mac, and apt-get for ubuntu
#packages = get_packages()
#print packages
