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

# Regex for "root".
# Pattern: ^(r|root)$
declare -r ROOT_REGEX='^(r|root)$'

# Regex for "user".
# Pattern: ^(u|user)$
declare -r USER_REGEX='^(u|user)$'

# Regex for "both".
# Pattern: ^(b|both)$
declare -r BOTH_REGEX='^(b|both)$'

# Regex for "switch".
# Pattern: ^(s|switch)
declare -r SWITCH_REGEX='^(s|switch)$'

# Regex for "build".
# Pattern: (b|build)$
declare -r BUILD_REGEX='^(b|build)$'

# Regex for "none".
# Pattern: ^(n|none)$
declare -r NONE_REGEX='^(n|none)$'

## Functions

# Applies the configuration for NixOS.
# Usage: apply_root_config
apply_root_config()
{
    sudo rm /etc/nixos/configuration.nix
    sudo rm -rf /etc/nixos/Modules
    sudo cp -r nixos/ /etc/
    chown "$USER" ./nixos/*
}

# Applies the configuration for Home Manager.
# Usage: apply_home_config
apply_home_config()
{
    rm -rf ~/.config/home-manager/
    cp -r home-manager/ ~/.config/
}

## Main (Entry Point)

if [[ ! $(command -v nix-channel) ]]; then
    device=$([[ -f '/etc/profile.d/nix.sh' ]] && echo 'terminal' || echo 'system' )
    readonly device
    fail 1 "$0" "> Nix was not detected. If you have just installed Nix, please restart your $device to load the Nix variables."
fi

# Contains the scope of the update.
# Values: root, user, or both
scope=$(
    case "${1,,}" in
        r|root|u|user|b|both) echo "${1,,}" ;;
        *) get_valid_input '> Would you like to update the configuration for root, user, or both? [r/u/b]: ' "$ROOT_REGEX" "$USER_REGEX" "$BOTH_REGEX"  ;;
    esac
)
readonly scope

update_type=$(
    case "${2,,}" in
        s|switch|b|build|n|none) echo "${2,,}" ;;
        *) get_valid_input '> Would you like to build and switch to the new configuration [s], just build it [b], or do nothing [n]? [s/b/n]: ' "$SWITCH_REGEX" "$BUILD_REGEX" "$NONE_REGEX"    ;;
    esac
)
# Contains the type of the update.
# Values: switch, build, or none
update_type=$(
    case "${update_type,,}" in
        s|switch) echo "switch"                 ;;
        b|build) echo 'build' ;;
        n|none) echo 'none'                     ;;
        *) fail 1 "$0" "Failed parsing 'update_type'. Value: $update_type"    ;;
    esac
)
readonly update_type

# Check if the Nix formatter is installed before
# running it on all configuration files.
if [[ $(command -v nixpkgs-fmt) ]]; then
    echo '> Formatting configuration files.'
    nixpkgs-fmt ./
fi

# Determines whether the root configuration should be updated or not.
# Values: Non-empty string if update should be performed, empty string if it should not.
update_root=$([[ -d '/etc/nixos/' && ($scope =~ $ROOT_REGEX || $scope =~ $BOTH_REGEX) ]] && echo 'true' || echo '')
readonly update_root

# Determines whether the user configuration should be updated or not.
# Values: Non-empty string if update should be performed, empty string if it should not.
update_user=$([[ -d "$HOME/.config/home-manager/" && ($scope =~ $USER_REGEX || $scope =~ $BOTH_REGEX) ]] && echo 'true' || echo '')
readonly update_user

# Updating files

if [[ $update_root && ! $(sudo -v) ]]; then
    echo '> Updating root configuration.'
    apply_root_config
fi

if [[ $update_user ]]; then
    echo '> Updating user configuration.'
    apply_home_config
fi

# Updating system

if [[ $update_root && ! $update_type =~ $NONE_REGEX && ! $(sudo -v) ]]; then
    announce '> Applying root configuration.'
    sudo nix-channel --update && sudo nixos-rebuild "$update_type"
fi

if [[ $update_user && ! $update_type =~ $NONE_REGEX ]]; then
    announce '> Applying user configuration.'

    # Remove the old Firefox profile backups, if they exist.
    delete_if_exists "${HOME}/.mozilla/firefox/insecure/search.json.mozlz4.backup"
    delete_if_exists "${HOME}/.mozilla/firefox/${USER}/search.json.mozlz4.backup"
    delete_if_exists "${HOME}/.mozilla/firefox/ephemeral/search.json.mozlz4.backup"    

    nix-channel --update && home-manager "$update_type" -b backup
fi

echo "> Done. $([[ $(command -v nixos-version) ]] && echo '' || echo 'New deskotp entries may require a session restart in order to load.')"