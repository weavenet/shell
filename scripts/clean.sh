#!/bin/bash

set -e

image=$1

for i in `docker ps -a |grep run_shell.sh |awk '{print $1}'`; do
    echo "Removing container '$i'."
    docker rm $i
done

echo "Removing image '$image'"
docker rmi --force $image
