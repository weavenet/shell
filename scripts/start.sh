#!/bin/bash

set -eu

image=$1

echo "Starting container."

docker run -d -p 22:22 -v ~/code:/home/ec2-user/code $image

echo "Container succesfully started."
