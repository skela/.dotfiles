export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export TERM="xterm-color"
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

alias poweroff="sudo shutdown -h now"

alias aliases="cat ~/.bash_profile"

alias inkscape="/Applications/Inkscape.app/Contents/Resources/bin/inkscape"

alias convertall_to_appletv="for f in *; do HandBrakeCLI -i "$f" -o "~/Desktop/$f.mp4" --preset="AppleTV"; done"

alias simple_web_service="sh ~/Dropbox/Scripts/simple_web_service.sh"

alias gitch="git diff > ~/Desktop/gitch ; mate ~/Desktop/gitch"

alias yt="youtube-dl"

alias vlc='/Applications/VLC.app/Contents/MacOS/VLC -I rc'

alias mine1="sh ~/Applications/DiabloMiner/DiabloMiner-OSX.sh --url http://skela_worker1:2vf8IYjhaBa2uJ@us2.eclipsemc.com:8337/ -w 64";
alias mine2="sh ~/Applications/DiabloMiner/DiabloMiner-OSX.sh --url http://skela_worker2:sUTD4b2oYFSxa6@us2.eclipsemc.com:8337/ -w 64";

function ff { osascript -e 'tell application "Finder"'\
 -e "if (${1-1} <= (count Finder windows)) then"\
 -e "get POSIX path of (target of window ${1-1} as alias)"\
 -e 'else' -e 'get POSIX path of (desktop as alias)'\
 -e 'end if' -e 'end tell'; };\

function cdff { cd "`ff $@`"; };

##
# Your previous /Users/skela/.bash_profile file was backed up as /Users/skela/.bash_profile.macports-saved_2013-03-25_at_03:14:57
##

# MacPorts Installer addition on 2013-03-25_at_03:14:57: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=$PATH:/Users/skela/Applications/Play
