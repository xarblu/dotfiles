#!/usr/bin/env bash

# Various utility functions

# printf wrapper printing to STDERR
function eprintf() {
    if (( ${#} < 1 )); then
        eprintf --error "usage: {--info,--warn,--error} format_string [format_variables...]\n"
        return 1
    fi

    local severity
    local format_string
    local -a format_variables

    local arg
    while (( ${#} > 0 )); do
        arg="${1}"; shift
        case "${arg}" in
            --info) severity=info ;;
            --warn) severity=warn ;;
            --error) severity=error ;;
            --*)
                eprintf --error "Unknown flag: %s\n" "${arg}"
                return 1
                ;;
            *)
                format_string="${arg}"
                break
                ;;
        esac
    done
    format_variables=( "${@}" )
    
    if [[ -z "${format_string}" ]]; then
        eprintf --error "No format_string was provided\n"
        return 1
    fi

    # prepend caller if set
    if (( "${#FUNCNAME[@]}" > 1)); then
        format_string="${FUNCNAME[1]}: ${format_string}"
    fi
    
    # prepend severity indicator
    case "${severity}" in
        info) format_string=" \e[92;1m*\e[0m ${format_string}" ;;
        warn) format_string=" \e[93;1m*\e[0m ${format_string}" ;;
        error) format_string=" \e[91;1m*\e[0m ${format_string}" ;;
        *) format_string=" \e[90;1m*\e[0m ${format_string}" ;;
    esac

    # shellcheck disable=SC2059
    printf "${format_string}" "${format_variables[@]}" 1>&2
}

# source a file if it exists, print and return error if not
function checked_source() {
    if (( ${#} != 1 )); then
        eprintf --error "Usage: file_to_source\n"
    fi
    
    local file="${1}"

    if [[ -f "${file}" ]]; then
        # shellcheck disable=SC1090
        source -- "${file}"
    else
        eprintf --error "File does not exist %s\n" "${file}"
        return 1
    fi
}

# create a directory if it doesn't exist
# with fancy printing
function mkdir_if_not_exists() {
    if (( ${#} != 1 )); then
        eprintf --error "Usage: exactly_one_directory\n"
        return 1
    fi

    if [[ ! -d "${1}" ]]; then
        eprintf --info "%s does not exist. Creating...\n" "${1}"
        if ! mkdir -p "${1}"; then
            eprintf --error "Could not create %s\n" "${1}"
            return 1
        fi
    fi
}

# create a file if it doesn't exist
# with fancy printing
function mkfile_if_not_exists() {
    if (( ${#} != 1 )); then
        eprintf --error "Usage: exactly_one_file\n"
        return 1
    fi

    if [[ ! -f "${1}" ]]; then
        eprintf --info "%s does not exist. Creating...\n" "${1}"
        if ! touch "${1}"; then
            eprintf --error "Could not create %s\n" "${1}"
            return 1
        fi
    fi
}

# check if we have a list of commands
# returns 1 if any of them are missing
function has_cmds() {
    if (( ${#} < 1 )); then
        eprintf --error "Usage: cmd...\n"
        return 1
    fi
    
    local cmd
    for cmd; do
        if ! command -v "${cmd}" >/dev/null; then
            if [[ -n "${VERBOSE}" ]]; then
                eprintf --error "Missing command %s\n" "${cmd}"
            fi
            return 1
        fi
    done
    return 0
}
