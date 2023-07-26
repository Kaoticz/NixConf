#!/usr/bin/env bash

#########
# Convenience script to install the Nix package manager
# and Home Manager's standalone version. Theoretically
# compatible with any Linux distribution and MacOS.
#########
# Usage:
## ./first_setup.sh
#########

# Make the script abort on error.
set -e

# Import helper functions.
source ./ShellLibs/helpers.sh

## Constants

# Regex for Home Manager's update channel.
# Pattern: https:\/\/github\.com\/nix-community\/home-manager\/archive\/release-([0-9]+\.[0-9]+)\.tar\.gz
declare -r HMNGR_REGEX='https:\/\/github\.com\/nix-community\/home-manager\/archive\/release-([0-9]+\.[0-9]+)\.tar\.gz'

# Warning telling the user to visit https://nixos.org/download.html.
declare -r CONSULT_NIX='Visit https://nixos.org/download.html if you are not sure.'

## Functions

# Checks if the current OS uses Systemd as its init system.
# Usage: has_systemd
# Returns: Non-empty string if it's using Systemd, empty string if it's not.
has_systemd()
{
    if [[ "$(ps -o comm= 1)" == 'systemd' ]]; then
        echo 'true'
    else
        echo ''
    fi
}

# Checks if the current OS has SELinux enabled.
# Usage: is_selinux_active
# Returns: Non-empty string if it's enabled, empty string if it's disabled.
is_selinux_active()
{
    if [[ $(command -v sestatus) && $(sestatus | grep -m 1 "SELinux status" | awk '{print $NF}') == 'enabled' ]]; then
        echo 'true'
    else
        echo ''
    fi
}

# Checks if the current user has administrator privileges.
# Usage: is_sudoer
# Returns: Non-empty string if the user has administrator privileges, empty string if it doesn't.
is_sudoer()
{
    if [[ $(sudo -v) ]]; then
        echo ''
    else
        echo 'true'
    fi
}

# Installs the Nix package manager on the current system.
# Remarks: Nix can only be installed system-wide if:
# 1) Systemd is used as the init system.
# 2) SELinux is not present or disabled.
# 3) The user has root administrator privileges.
# If these conditions are not met, Nix can only be installed for the current user.
install_nix()
{
    local option;
    local input;

    if [[ $OSTYPE =~ darwin ]]; then
        option=''
    elif [[ $(has_systemd) && ! $(is_selinux_active) && $(is_sudoer) ]]; then
        input=$(get_valid_input "> Would you like to install Nix system-wide [y] (recommended) or just for your current user [n]? $CONSULT_NIX [y/n]: " $YES_REGEX $NO_REGEX)
        option=$([[ ${input,,} =~ $YES_REGEX ]] && echo '--daemon' || echo '--no-daemon')
    else
        input=$(get_valid_input "> Your system doesn't seem to support a system-wide installaion of Nix. Would you like to proceed anyway and install it just for your current user? $CONSULT_NIX [y/n]: " $YES_REGEX $NO_REGEX)
        [[ ${input,,} =~ $NO_REGEX ]] && fail 1 'install_nix' 'Installation cancelled by the user'
    fi
    
    sh <(curl -L https://nixos.org/nix/install) "$option"
}

# Install Home Manager on the current system.
# Remarks: This is a standalone installation - https://nix-community.github.io/home-manager/index.html#sec-install-standalone
# Returns: The version of Home Manager that got installed.
install_home_manager()
{
    local -r html_content=$(curl -s 'https://nix-community.github.io/home-manager/')

    if [[ ! $html_content =~ $HMNGR_REGEX ]]; then
        fail 1 'install_home_manager' 'Home Manager'\''s update channel was not found. Aborting.'
    fi

    nix-channel --add "${BASH_REMATCH[0]}" 'home-manager'
    nix-channel --update
    nix-shell '<home-manager>' -A install

    echo "${BASH_REMATCH[1]}"
}

## Main (Entry Point)

# Check if the OS is supported.
if [[ ! $OSTYPE =~ linux && ! $OSTYPE =~ darwin ]]; then
    fail 1 "$0" 'This script is only supported on Linux and MacOS.'
fi

# Install the Nix package manager.
if [[ $(command -v nix-env) ]]; then
    echo '> Nix detected, skipping installation.'
else
    echo '> Nix was not detected. Installing...'
    install_nix
fi

# Install Home Manager
if [[ $(command -v home-manager) ]]; then
    echo '> Home Manager detected, skipping installation.'
else
    echo '> Home Manager not detected. Installing...'
    install_home_manager > ./home-manager/Config/ver
fi

echo "> Setup done. Run './update.sh' to apply the configuration files."