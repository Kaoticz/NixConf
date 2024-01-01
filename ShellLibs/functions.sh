#!/usr/bin/env bash

## Constants

# ANSI red color.
declare -r RED='\033[0;31m'

# ANSI yellow color.
declare -r YELLOW='\033[0;33m'

# ANSI default color.
declare -r RESET_COLOR='\e[0m'

# Prints a warning to stderr.
# Usage: warn <function_name> <error_message>
warn()
{
    echo -e "${YELLOW}$1: ${*:2}${RESET_COLOR}" >&2
}

# Prints a warning to stderr and exits with the specified error code.
# Usage: fail <error_code> <function_name> <error_message>
fail()
{
    echo -e "${RED}$2: ${*:3}${RESET_COLOR}" >&2
    exit "$1"
}

# Executes a function, halting execution of the script if errors occur.
# Usage: fail_if <function_call>
fail_if()
{
    "$@" || fail $? "Error $?" "failed to execute '$*'"
}

# Safely executes a function, printing errors to stderr but not halting execution of the script.
# Usage: try <function_call>
try()
{
    "$@" || warn "Error $?" "failed to execute '$*'"
}

# Deletes the file or folder at the specified path.
# Usage: delete_if_exists <path>
delete_if_exists()
{
    if [[ -f $* ]] || [[ -d $* ]]; then
        rm -rf "$*"
    fi
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
    local breakout=''

    while [[ -z $input || -z $breakout ]]; do
        input=$(get_input "$1")

        for regex in "${@:2}"; do   # @:2 - Get all arguments, except the first one.
            if [[ ${input,,} =~ $regex ]]; then # Case-insensitive matching
                breakout='true'
                break
            fi
        done
    done
    
    echo "$input"
}