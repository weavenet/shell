#!/bin/bash

process='run_shell.sh'

echo "Looking for containers runing '$process'."
container_id=`docker ps | grep run_shell.sh |awk '{print $1}'`

if [ -z "$container_id" ]; then
    echo "Container running process '$process' not found."
    exit 0
fi

echo "Stopping container '$container_id'."
docker stop ${container_id}

echo "Stopping container completed."
