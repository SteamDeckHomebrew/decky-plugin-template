#!/bin/sh
set -e

if [ -f /.dockerenv ]; then
	apk add --no-cache python3 py3-pip
fi
pip3 install stickytape
stickytape src/py/main.py > main.py