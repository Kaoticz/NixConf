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

# Regex to find the release version of a NixOS installation from the command 'nixos-version'
# Pattern: ^[0-9]+\.[0-9]+
declare -r NIXOS_REGEX='^[0-9]+\.[0-9]+'

# Regex for Home Manager's update channel.
# Pattern: https:\/\/github\.com\/nix-community\/home-manager\/archive\/release-([0-9]+\.[0-9]+)\.tar\.gz
declare -r HMNGR_REGEX='https:\/\/github\.com\/nix-community\/home-manager\/archive\/release-([0-9]+\.[0-9]+)\.tar\.gz'

# Warning telling the user to visit https://nixos.org/download.html.
declare -r CONSULT_NIX='Visit https://nixos.org/download.html if you are not sure.'

# Defines the location of the temporary installation file, used to check
# if the user restarted the shell after installing Nix.
declare -r FLAG_FILE_PATH='./temp'

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
        input=$(get_valid_input "> Would you like to install Nix system-wide [y] (recommended) or just for your current user [n]? $CONSULT_NIX [y/n]: " "$YES_REGEX" "$NO_REGEX")
        option=$([[ ${input,,} =~ $YES_REGEX ]] && echo '--daemon' || echo '--no-daemon')
    else
        input=$(get_valid_input "> Your system doesn't seem to support a system-wide installaion of Nix. Would you like to proceed anyway and install it just for your current user? $CONSULT_NIX [y/n]: " "$YES_REGEX" "$NO_REGEX")
        [[ ${input,,} =~ $NO_REGEX ]] && fail 1 'install_nix' 'Installation cancelled by the user'
    fi
    
    sh <(curl -L https://nixos.org/nix/install) "$option"
}

# Install Home Manager on the current system.
# Usage: install_home_manager <update_channel>
# Remarks: This is a standalone installation - https://nix-community.github.io/home-manager/index.html#sec-install-standalone
install_home_manager()
{
    nix-channel --add "$*" 'home-manager'
    nix-channel --update
    nix-shell '<home-manager>' -A install
}

# Gets the current release channels of NixOS and Home Manager.
# Usage: get_release_channels
# Returns: An array where the first element is the update channel for NixOS, the second element is for Home Manager, and the third element is the version of Home Manager.
get_release_channels()
{
    # I'm trusting that Home Manager's version is synchronized to NixOS'.
    local -r html_content=$(curl -s 'https://nix-community.github.io/home-manager/')

    if [[ ! $html_content =~ $HMNGR_REGEX ]]; then
       fail 1 'get_release_channels' 'Home Manager'\''s update channel was not found. Aborting.'
    fi

    echo "https://nixos.org/channels/nixos-${BASH_REMATCH[1]}" "${BASH_REMATCH[@]}"
}

# Gets the NixOS release version of the current system.
# Usage: get_nixos_release
# Returns: The release version of the system
get_nixos_release()
{
    local -r full_version=$(nixos-version)

    if [[ ! $full_version =~ $NIXOS_REGEX ]]; then
        fail 1 'get_nixos_release' 'This function only works on NixOS.'
    fi

    echo "${BASH_REMATCH[0]}"
}

# Forces the user to restart the shell so the Nix envars get loaded.
# Usage: enforce_shell_restart
enforce_shell_restart()
{
    if [[ -f $FLAG_FILE_PATH && ! $(command -v nix-channel) ]]; then
        fail 1 'enforce_shell_restart' 'Please, restart your terminal and execute this script again.'
    elif [[ -f $FLAG_FILE_PATH ]]; then
        rm $FLAG_FILE_PATH
    fi
}

## Main (Entry Point)

# Check if the OS is supported.
if [[ ! $OSTYPE =~ linux && ! $OSTYPE =~ darwin ]]; then
    fail 1 "$0" 'This script is only supported on Linux and MacOS.'
fi

# Guard against lazy users.
enforce_shell_restart

# Install the Nix package manager.
if [[ $(command -v nixos-version) && ! -d './nixos/Config/nixos-version' ]]; then
    mkdir -p ./nixos/Config/
    get_nixos_release > ./nixos/Config/nixos-version
elif [[ $(command -v nix-env) ]]; then
    echo '> Nix detected, skipping installation.'
else
    echo '> Nix was not detected. Installing...'
    install_nix

    echo '> Nix installed successfully. Please, restart your terminal and execute this script again.'
    touch $FLAG_FILE_PATH
    exit 0
fi

# Install Home Manager
if [[ $(command -v home-manager) ]]; then
    echo '> Home Manager detected, skipping installation.'
else
    echo '> Home Manager not detected. Installing...'

    # Get release channels
    IFS=" "
    read -ra matches <<< "$(get_release_channels)"

    # Add NixOS' channel. This is needed due to a bug in the installation
    # script that prevents the script from adding the channel.
    nix-channel --add "${matches[0]}" 'nixpkgs'

    # Add Home Manager's channel and install it.
    install_home_manager "${matches[1]}"

    # Create the version file.
    mkdir -p ./home-manager/Config/
    echo "${matches[2]}" > ./home-manager/Config/hm-version
fi

echo "> Setup done. Execute './update.sh' to apply the configuration files."