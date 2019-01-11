#!/bin/bash

# push the specified dockerfile to the ucb-bar docker repo with specified tag
# ./push_to_dockerhub.sh folderToBuildAndPush
#
# requires you to have docker and have permissions to push to docker repo

cd $1
sudo docker build -t ucbbar/riscv-docker-images:$1 .
sudo docker push ucbbar/riscv-docker-images:$1

