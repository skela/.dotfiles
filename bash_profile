# Colors

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TERM="xterm-color"
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias poweroff="sudo shutdown -h now"
alias aliases="cat ~/.bash_profile"
alias inkscape="/Applications/Inkscape.app/Contents/Resources/bin/inkscape"
alias lt="/Applications/LightTable.app/Contents/MacOS/node-webkit"
alias convertall_to_appletv="for f in *; do HandBrakeCLI -i "$f" -o "~/Desktop/$f.mp4" --preset="AppleTV"; done"
alias gitch="git diff > ~/Desktop/gitch ; mate ~/Desktop/gitch"
alias rmtrash="rm -rdf ~/.Trash/*"
alias yt="youtube-dl"
alias gits="git status"
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC -I rc'
alias vtf="open ~/.dotfiles/res/vi-vim-cheat-sheet.gif"
alias edit="/usr/bin/subl"
alias locate='python ~/.dotfiles/scripts/locate.py $1'
alias itunes-helper='python /Volumes/Terra/code/itunes-helper/itunes-helper.py $1'
alias sweep='python ~/.dotfiles/scripts/sweep.py'
alias android-screenshot='adb shell /system/bin/screencap -p /sdcard/screenshot.png ; adb pull /sdcard/screenshot.png $1'
alias rod='python ~/.dotfiles/libs/r/rod.py'
alias pycharm='/Applications/PyCharm.app/Contents/MacOS/pycharm'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='python ~/.dotfiles/scripts/alert.py "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Functions

function ff { osascript -e 'tell application "Finder"'\
 -e "if (${1-1} <= (count Finder windows)) then"\
 -e "get POSIX path of (target of window ${1-1} as alias)"\
 -e 'else' -e 'get POSIX path of (desktop as alias)'\
 -e 'end if' -e 'end tell'; };\

function cdff { cd "`ff $@`"; };

# Path Exports

export PATH=$PATH:/Users/skela/Applications/Play
export PATH=$PATH:/Volumes/Terra/Applications/Android/platform-tools
export PATH=$PATH:/Volumes/Terra/Applications/Android/build-tools/19.0.3
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

##
# Your previous /Users/skela/.bash_profile file was backed up as /Users/skela/.bash_profile.macports-saved_2014-11-10_at_14:24:09
##

# MacPorts Installer addition on 2014-11-10_at_14:24:09: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

