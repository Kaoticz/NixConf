#!/usr/bin/env bash

# Get the directory of this script.
current_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly current_directory

# Source code relative to this script directory.
source "$current_directory/constants.sh"
source "$current_directory/functions.sh"