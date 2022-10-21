#!/bin/bash

set -e

image=$1

echo "Starting container."

if [ $SHELL_MOUNT_CODE ]; then
    SHELL_MOUNT_CODE_CMD="-v $HOME/code:/home/user/code"
fi

cmd="docker run -d -p 2222:22 $SHELL_MOUNT_CODE_CMD $image"

echo "Starting command with '$cmd'."

container_id=`$cmd`

echo "Container '$container_id' succesfully started."
