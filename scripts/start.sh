#!/bin/bash

set -eu

echo "Starting container."

docker run -d -p 22:22 -v ~/code:/home/ubuntu/code $IMAGE

echo "Container succesfully started."
