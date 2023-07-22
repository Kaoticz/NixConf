#!/usr/bin/env bash

# Make the script abort on error
set -e

# Applies the configuration for NixOS.
# Usage: apply_root_config
apply_root_config()
{
    sudo rm /etc/nixos/configuration.nix
    sudo rm -rf /etc/nixos/Modules
    sudo cp -rv nixos/ /etc/
    chown "$USER" nixos/*
}

# Applies the configuration for Home Manager.
# Usage: apply_home_config
apply_home_config()
{
    rm -rf ~/.config/home-manager/
    cp -rv home-manager/ ~/.config/
}

echo -e '\n> Applying root configuration\n'
apply_root_config

echo -e '\n> Applying user configuration\n'
apply_home_config