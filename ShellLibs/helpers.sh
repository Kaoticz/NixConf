#!/usr/bin/env bash

current_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly current_directory

source "$current_directory/constants.sh"
source "$current_directory/functions.sh"