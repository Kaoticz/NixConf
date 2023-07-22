#!/usr/bin/env bash

echo -e '> Copying root configuration\n'
sudo cp -rv nixos/ /etc/

echo -e '> Copying user configuration\n'
cp -rv home-manager/ ~/.config/