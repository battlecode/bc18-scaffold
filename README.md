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

The Battlecode server will initialize, after a few moments, you will be shown a prompt labelled `To play games open http://localhost:6147/run.html in your browser`. Do not actually go there; Docker will use a different IP than localhost by default.

You can no longer input commands into Docker Toolbox, this is normal.

Navigate to http://192.168.99.100:6147/run.html in your browser. This may be different depending on your configuration -- if this doesn't work, check the IP upon instantiating Docker Quickstart (you will see a line of the form `docker is configured to use...`).

#### FAQ (for Docker Toolbox):
1. How do I play a game?

 Ignore the variables for the time being unless you want to specifically test something intensive. Select players from the dropdowns on the right as well as a map, and click "Run Game". A pop-up will display showing the logs of each of the 4 bots (2 bots x 2 maps) while the game runs. When the game ends, the pop-up will disappear and the replay will be in the scaffold folder (the same folder where the bots are located).

2. How can I see the replay?

 Download the viewer client from http://battlecode.org/#/materials/releases for your operating system. Click on the button with 3 horizontal bars, which will bring up a filesystem that you can select the replay from. Navigate to it, click on the replay, and click "select" in the bottom right of the filesystem window. Then, click the play button in the top right. You can zoom out using the mouse wheel and move your vision using WASD or the arrow keys.

3. I ran a game with a broken bot, and now I can't run another game!

 Open another Docker Quickstart window (start.sh) and type the following command: `docker ps`. This will display the information of the currently running container. Take note of the container ID (the first entry) and type `docker kill {ID}`. You only need to type the first couple characters, e.g. `docker kill e06`. Go back to the original quickstart window and type `bash run.sh` again.

4. Running `bash run.sh` keeps downloading a lot of garbage files!

 Again open another Docker Quickstart window (start.sh) and type the following command: `docker container ls -a`. This will display the information of all containers, including the running one. Type `docker container rm {id}` for each of the non-running containers. Again you only need to type the first few characters, e.g. `docker container rm ff4`.

 A possibly more robust solution to this problem is via the `--rm` flag. Running `bash run.sh --rm` should, in theory, remove the container after termination.

5. The Python example bot explodes!

 There is currently an API bug tied to building blueprints. If you avoid `gc.blueprint()` then you should be fine for the time being.
 
6. Docker is taking up too much memory! / I get out of memory errors when running `run.sh`!

 Docker saves some information between runs called images, containers, and volumes. Unchecked, these can quickly take over many gigs of storage. Occasionally, run the following 4 lines:

 `docker stop $(docker ps -q)`
`docker container rm $(docker container ls -aq)`
`docker volume rm $(docker volume ls -q)$`
`docker volume prune`

 which should free up a lot of space.

7. I get a 'We dun goof no map found' error!

 Ignore it. This should happen when using the test map.

8. I don't see any players/maps in the dropdown and/or my console says that `/player` can't be found!

 This one is pretty tricky to track down. Try looking at your `run.sh` file and changing `/players` to `/player` if necessary. You can also try running the `pwd` command in your scaffold directory and replacing `$PWD` in `run.sh` with that absolute path. Additionally make sure your filepath doesn't contain any spaces, special characters, etc. that may confuse the parser.
 
9. The Python bot crashes with an error of the form `can't open file run.py`!

 The issue is most likely that you are using Windows line endings (\r\n) rather than Unix line endings (\n) which confuses the shell script and gives some silly error. To fix this, make sure to convert all your `run.sh` files to Unix format before running a game. You can accomplish this with an editor like Notepad++ (Edit -> EOL Conversion -> Unix/OSX Format) or the `dos2unix` command line tool (e.g. `dos2unix */run.sh`).
