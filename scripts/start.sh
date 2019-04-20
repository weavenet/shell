#!/bin/bash

set -eu

echo "Starting container."

docker run -d -p 22:22 $IMAGE

echo "Container succesfully started."
