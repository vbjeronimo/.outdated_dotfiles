#!/bin/bash

setxkbmap -variant colemak
autorandr --change
nm-applet &
feh --bg-scale ~/pictures/wallpapers/active.png &
