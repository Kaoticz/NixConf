#!/usr/bin/env bash

# Make the script abort on error
set -e

## Constants

# Regex for "yes".
# Pattern: ^(yes|ye|y)$
declare -r YES_REGEX='^(yes|ye|y)$'

# Regex for "no".
# Pattern: ^(no|n)$'
declare -r NO_REGEX='^(no|n)$'

# Regex for Home Manager's update channel.
# Pattern: https:\/\/github\.com\/nix-community\/home-manager\/archive\/release-([0-9]+\.[0-9]+)\.tar\.gz
declare -r HMNGR_REGEX='https:\/\/github\.com\/nix-community\/home-manager\/archive\/release-([0-9]+\.[0-9]+)\.tar\.gz'

# Warning telling the user to visit https://nixos.org/download.html.
declare -r CONSULT_NIX='Visit https://nixos.org/download.html if you are not sure.'

## Functions

# Prints a warning to stderr.
# Usage: warn <function_name> <error_message>
warn()
{
    echo "$1: ${*:2}" >&2
}

# Prints a warning to stderr and exits with the specified error code.
# Usage: fail <error_code> <function_name> <error_message>
fail()
{
    warn "${@:2}"
    exit "$1"
}

# Safely executes a function, printing errors to stderr but not halting execution of the script.
# Usage: try <function_call>
try()
{
    "$@" || fail 1 "failed to run '$*'"
}

# Prompts the user to type something with a message.
# Usage: get_input <message>
# Returns: a string with the user's input.
get_input()
{
    read -rp "$*" input
    echo "$input"
}

# Prompts the user to type a message that meets one or more patterns.
# Usage get_valid_input <message> <expected_patterns...>
# Remarks: this function requires at least 2 arguments (the message and one valid input).
# Returns: a string with the user's input or error code 3 - see Remarks.
get_valid_input()
{
    if (( $# <= 1 )); then
        fail 1 'get_valid_input' 'This function requires 2 or more arguments.'
    fi

    local input=''
    local -ra answers=("${@:2}")    # Get all arguments, except the first one.

    # Keep looping while $input is not a valid answer.
    while [[ -z $input || ! ${answers[*]} =~ ${input,,} ]]; do
        input=$(get_input "$1")
    done
    
    echo "$input"
}

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
    local option=; option=$([[ $(has_systemd) && ! $(is_selinux_active) && $(is_sudoer) ]] && echo '--daemon' || echo '--no-daemon')
    local input=;

    if [[ $option == '--daemon' ]]; then
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