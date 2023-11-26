#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# default browser
export BROWSER=opera
xdg-mime default opera.desktop x-scheme-handler/http
xdg-mime default opera.desktop scheme-handler/http
xdg-mime default opera.desktop x-scheme-handler/https
xdg-mime default opera.desktop scheme-handler/https
xdg-mime default opera.desktop text/html
xdg-mime default opera.desktop text/xml

setxkbmap -option ctrl:swapcaps

xrdb -merge ~/.Xresources

# Guestures
xinput set-prop "10" "libinput Click Method Enabled" 0 1

exec xmonad
