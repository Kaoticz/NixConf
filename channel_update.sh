#!/usr/bin/env bash

#########
# Convenience script to update and rebuild the Nix
# configuration files contained in this repository.
#########
# Usage:
## ./update.sh
## ./update.sh <scope>
## ./update.sh <scope> <update_type>
#########
## <scope>: 'root', 'user', or 'both'
## <update_type>: 'switch', 'build', or 'none'
#########

# Make the script abort on error.
set -e

# Import helper variables and functions.
source ./ShellLibs/helpers.sh

## Constants

# Regex for NixOS versions
# Pattern: ^(\d+\.\d+)$
declare -r VERSION_REGEX='^(\d+\.\d+)$'

## Functions

# Updates the channels used by Home Manager.
# Usage: update_home_manager <channel_version>
update_home_manager()
{
    if [[ -z $1 ]]; then
        fail 1 'update_home_manager' 'This function requires 1 argument.'
    fi

    nix-channel --add "https://nixos.org/channels/nixos-${1}" "nixpkgs"
    nix-channel --add "https://github.com/nix-community/home-manager/archive/release-${1}.tar.gz" "home-manager"
    nix-channel --update
}

# Updates the channels used by NixOS.
# Usage: update_nixos <channel_version>
update_nixos()
{
    if [[ -z $1 ]]; then
        fail 1 'update_nixos' 'This function requires 1 argument.'
    fi

    sudo nix-channel --add "https://nixos.org/channels/nixos-${1}" "nixos"
    sudo nix-channel --update
}

## Main (Entry Point)

if [[ ! $(command -v nix-channel) ]]; then
    device=$([[ -f '/etc/profile.d/nix.sh' ]] && echo 'terminal' || echo 'system' )
    readonly device
    fail 1 "$0" "> Nix was not detected. If you have just installed Nix, please restart your $device to load the Nix variables."
fi

nix_version=$(get_valid_input '> Which Nix version would you like to switch to? (ex: 24.11): ' "$VERSION_REGEX")
readonly nix_version

announce '> Updating user channel.'
update_home_manager "$nix_version"

if [[ -d '/etc/nixos/' ]]; then
    announce '> Updating root channel.'
    update_nixos "$nix_version"
fi

echo "> Done. Updated all channels to version ${nix_version}"