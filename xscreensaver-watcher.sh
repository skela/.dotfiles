#!/bin/bash

process() {
while read input; do 
  case "$input" in
    UNBLANK*)	g810-led -a ff0000 ;;
    LOCK*)	g810-led -a 0a ;;
  esac
done
}

/usr/bin/xscreensaver-command -watch | process

