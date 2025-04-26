#!/bin/bash

# clean out and rebuild the docker image

DIR=`pwd`
NAME=`basename ${DIR}`
docker compose down
docker volume rm $(docker volume ls -q --filter name=${NAME})
docker network rm ${NAME}_default
docker image rm ${NAME}-web
docker compose build
