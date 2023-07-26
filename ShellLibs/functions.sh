#!/usr/bin/env bash

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