#!/usr/bin/env bash
set -e
set -o nounset

echo "installing pip, running as user: $USER"
easy_install pip
pip install virtualenvwrapper
pip install fabric
