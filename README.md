# Scaffold for Battlecode 2018

This is how you run games!  To start, install docker, and make sure it's started.  

### Unix instructions

#### Mac:
Install docker for mac: https://www.docker.com/docker-mac

Clone the repo, or click https://github.com/battlecode/bc18-scaffold/archive/master.zip to download


#### Linux:
Install docker for your system.

Clone the repo, or click and run `sudo sh run.sh` in the directory.  Wait a while to download our code, then finally it will say:

`To play games open http://localhost:6147/run.html in your browser`

Follow its instructions, and start runnin them games! (warning, socket.bc18map may be buggy rn)

### Windows 10 Pro instructions

Windows 10 Professional or Enterprise: install https://www.docker.com/docker-windows

Windows 10 Home, Windows 8, Windows 7: install https://docs.docker.com/toolbox/toolbox_install_windows/

double click run.cmd

wait a while

When you get the message: `To play games open http://localhost:6147/run.html in your browser` you're good to go!

### Docker Toolbox Install Instructions

If you are running Windows 10 Home, Windows 8, or Windows 7, you must install Docker Toolbox in order to run the game.

Docker Toolbox can be installed from here: https://docs.docker.com/toolbox/toolbox_install_windows/

After installation, navigate to the install directory of Docker Toolbox (Most likely located in "C:\Program Files\Docker Toolbox")

Double-click the file labelled "start.sh"

Docker Toolbox will boot, after a moment, you will be prompted with a colourful whale and a command line interface.

Navigate to where your bc18-scaffold repository is located (Docker Toolbox is automatically started in your current User directory)

Type in "bash run.sh"

The Battlecode server will initialize, after a few moments, you will be shown a prompt labelled `To play games open http://localhost:6147/run.html in your browser`

You can no longer input commands into Docker Toolbox, this is normal.

Navigate to http://192.168.99.100:6147/run.html in your browser.