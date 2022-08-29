#!/usr/bin/env bash

export BUILD_NAME=$1
export DOCKER_USER=$2
export DOCKER_PSWD=$3

echo $DOCKER_PSWD | docker login -u $DOCKER_USER --password-stdin
docker run -d -p 8001:8001 kkushagra6/docker_todo:$BUILD_NAME
echo "Successfull"


