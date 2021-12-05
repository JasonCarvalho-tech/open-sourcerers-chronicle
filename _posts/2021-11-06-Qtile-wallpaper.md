---
layout: post
title:  "Different wallpaper for each screen in Qtile"
date:   2021-11-06 10:00:00
categories: qtile python linux
---

{% newthought 'I use [Qtile](http://www.qtile.org/)' %}{% sidenote 'One' 'Qtile is a free and open source tiling window manager written in python. Refer: [http://www.qtile.org](http://www.qtile.org/)' %} as the window manager for my system. The system is a laptop with one monitor connected via HDMI, but sometimes just the laptop. When I first installed Qtile I tried to set the wallpapers and failed. <!--more--> I could get the same wallpaper on both the laptop and HDMI display but not 2 different ones. Since then with a bit of python I have achieved that. The process is documented here.
I'm assuming you already have installed and set up qtile. All the code can be found in this repo: [https://github.com/JasonCarvalho-tech/qtile-config/tree/main](https://github.com/JasonCarvalho-tech/qtile-config/tree/main)

## TLDR: Setting the wallpaper
The wallpaper can be set by using a package called [feh](https://wiki.archlinux.org/title/Feh). If you use Arch Linux the package can be installed through the terminal by:
``` shell
$ sudo pacman -Sy feh
```
After installing wallpapers for 2 screens for instance can be set by running:
``` shell
$ feh --bg-center path/to/file/for/first/monitor path/to/file/for/second/monitor
```
Instead of the ```--bg-center``` flag you could use ```--bg-max``` or ```--bg-fill``` among others. Refer the [ArchWiki article](https://wiki.archlinux.org/title/Feh) for more examples or type:
``` shell
$ feh --help
``` 
to see more information about the flags and other options.
Note that the wallpapers set will be lost every session. The rest of this post will detail how to retain the wallpaper for the next session and then later how to program the wallpaper to change every day. Both of these processes are done by listening to qtile startup via hooks qtile provides.

## Setting up the screens.
Before setting up the screens, a script is run that will use xrandr to set the second screen's resolution and relative position to my laptop screen. I have put this script in my bin directory(which is in my PATH) so I can run it directly from console. The file is called acer-screen and these are it's contents.

``` shell
#!/bin/bash
xrandr --output HDMI1 --mode 1280x960 --right-of eDP1 ; xrandr --output HDMI-1-1 --mode 1280x960 --right-of eDP-1-1 ; xrandr --output HDMI-1 --mode 1280x960 --right-of eDP-1
```
the main command is ```xrandr --ouput HDMI1 --mode 1280x960 --right-of eDP1``` which sets the resolution of my second monitor, called HDMI1, to 1280 by 960 and sets it to the right of my laptop. The command is repeated with HDMI-1-1, eDP-1-1 and HDMI-1, eDP-1 because my monitor names change for some reason when I use [optimus-manager](https://github.com/Askannz/optimus-manager) to switch my graphics card mode, repeating the command with the alternate HDMI1 and eDP1 names will not be necessary if you don't use optimus manager. You might also have to change the resolution based on your monitor. Have a look at the ArchWiki post for more information on xrandr or use ```xrandr --help```. We will call this script when we start qtile when the system starts.

## Creating the python module
Instead of running the code directly in the qtile config.py file, we could run the code by making a module and then importing and running a function of the module in the qtile config file. This might make additional features easier to add. And also makes testing easier. You can test by running a test.py file that contains the import to the module and the functions. I created this module in the same directory as the qtile config file, which in my case is in ```~/.config/qtile/config.py```. Here is the directory structure for the module.
```
qtilehelper/
|-screens.py
|-__init__.py
```
The \_\_init\_\_.py file contains the following code: 
``` python
from . import screens
```
screens.py will contain the code to set up the screens and another function to set the wallpaper based on the day.
``` python
import os
import datetime
import gi
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk

def setupScreens():
    if Gdk.Display.get_default().get_n_monitors() == 2:
        os.system('acer-screen')

def setWallpaper():
    path = '/home/jason/Personal/Pictures/wallpaper/' #path to your wallpaper files
    wallpapers = os.listdir(path)
    day = int(datetime.datetime.now().timestamp())//86400
    wallpaper1_path = path + wallpapers[day%len(wallpapers)]
    if Gdk.Display.get_default().get_n_monitors() == 2:
        wallpaper2_path = path + wallpapers[(day%len(wallpapers)) - 1]
        os.system('feh --bg-max ' + wallpaper1_path + ' ' + wallpaper2_path)
    else:
        os.system('feh --bg-max ' + wallpaper1_path)
```
```setupScreens()``` is pretty self explanitory, it checks if there are 2 screens and if there are it runs the command ```acer-screen```.
```setWallpaper()``` needs a little bit of explanation. You need to set the path variable to wherever you wallpapers are stored. The day variable contains the number of days that has elapsed since January 1, 1970, we get this by dividing a POSIX timestamp by the number of seconds in a day(86400). Finding the modulus of this value and the ammount of files in the wallpaper directory we will get the wallpaper for the day. The if statement checks if there are 2 monitors, if there are 2, the script substracts 1 to get the wallpaper for my external monitor, and runs the command to set wallpapers for both screens. If there is only one monitor the command is run to set the wallpaper for one monitor.

## Using the module in the config with hooks
In order to run code when events occur in qtile, you have to utilize [hooks](https://docs.qtile.org/en/v0.18.0/manual/ref/hooks.html#ref-hooks). The 2 hooks of intrest to us are ```startup\_once()``` and ```startup()```. We will attach ```setupScreens()``` to ```startup\_once()``` and ```setWallpaper()``` to ```startup()```

Why do we set the functions to seperate hooks?
I too thought we could just set both to startup but this presents a problem. Let's say for some reason we want to set up a second monitor differently than in acer-screen, maybe it is a different monitor with a different resolution. We could set that monitor up using ```xrandr``` after start up and attempt to set the monitors by pressing ```Mod+Ctrl+r``` which will restart Qtile. Now we will hit a problem because the startup function will trigger and if we attached ```setupScreens()``` to ```startup()``` the chages we made using xrandr will be undone because ```acer-screen``` will be run.
To prevent this I attached ```setupScreens()``` to ```startup\_once()``` which only runs the first time qtile runs when you startup your computer.
Here is the code for ```config.py```, i.e. your qtile config file. I've only put the top portion as there is quite a lot of code in that file.
``` python
from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# custom imports
import qtilehelper as helper

@hook.subscribe.startup_once
def autostart():
    helper.screens.setupScreens()

@hook.subscribe.startup
def autostart():
    helper.screens.setWallpaper()

```
I have modified the default config file by placing the above code in the top right after the copyright notice. The wallpaper got applied when I restarted my computer.
Here is the repo with all the code: [https://github.com/JasonCarvalho-tech/qtile-config/tree/main](https://github.com/JasonCarvalho-tech/qtile-config/tree/main)
{% postauthor 'Jason Carvalho' %}
