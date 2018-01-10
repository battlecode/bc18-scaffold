#!/bin/sh

docker stop $(docker ps -q)
docker container rm $(docker container ls -aq)
docker volume rm $(docker volume ls -q)$
docker volume prune

docker run -it --privileged -p 16147:16147 -p 6147:6147 -v $PWD:/player --rm battlecode/battlecode-2018
