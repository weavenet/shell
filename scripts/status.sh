#!/bin/bash

set -e

docker ps | grep run_shell.sh |awk '{print $2 " " $1}'
