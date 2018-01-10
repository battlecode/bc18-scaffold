docker pull battlecode/battlecode-2018

docker run -it --privileged -p 16147:16147 -p 6147:6147 -v %~dp0:/players battlecode/battlecode-2018
