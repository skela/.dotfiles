export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export TERM="xterm-color"
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '


alias aliases="cat ~/.bash_profile"

alias inkscape="/Applications/Inkscape.app/Contents/Resources/bin/inkscape"

alias convertall_to_appletv="for f in *; do HandBrakeCLI -i "$f" -o "~/Desktop/$f.mp4" --preset="AppleTV"; done"

alias simple_web_service="sh ~/Dropbox/Scripts/simple_web_service.sh"

function ff { osascript -e 'tell application "Finder"'\
 -e "if (${1-1} <= (count Finder windows)) then"\
 -e "get POSIX path of (target of window ${1-1} as alias)"\
 -e 'else' -e 'get POSIX path of (desktop as alias)'\
 -e 'end if' -e 'end tell'; };\

function cdff { cd "`ff $@`"; };

