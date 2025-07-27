#!/usr/bin/env bash

###### Simple Plugin Installer + Loader

### Individual plugin helper functions

# installation steps for ble.sh
function __blesh_install__() {
    if ! has_cmds git make; then
        eprintf --error "ble.sh installation requires git and make\n"
    fi

    git clone --recursive --depth 1 --shallow-submodules \
        https://github.com/akinomyoga/ble.sh.git \
        "${BASH_PLUGDIR}/ble.sh"

    make -C "${BASH_PLUGDIR}/ble.sh"
}

# load steps for ble.sh
# NOTE: triple check locales if completion is funny
# you only want LANG=yourlang and LC_COLLATE=C
function __blesh_init__() {
    local blesh_file="${BASH_PLUGDIR}/ble.sh/out/ble.sh"
    if [[ ! -f "${blesh_file}" ]]; then
        eprintf --info "ble.sh not installed at %s. Installing...\n" "${blesh_file}"
        __blesh_install__
    fi

    # warn if mawk isn't available
    # gawk "works" but is suboptimal e.g. for multibyte chars
    if ! has_cmds mawk; then
        eprintf --warn "Recommended awk implementation mawk not found\n"
    fi
    
    # re-check in case install failed
    if [[ -f "${blesh_file}" ]]; then
        # shellcheck disable=SC1090
        source -- "${blesh_file}" --attach=none
    else
        eprintf --error "%s does not exist\n" "${blesh_file}"
        return 1
    fi
}

# finalize ble.sh
function __blesh_finalize__() {
    [[ -n "${BLE_VERSION}" ]] && ble-attach
}


### Meta functions to be called from main bashrc

# initialise plugins (install + load)
function __plugins_init__() {
    if [[ -z "${BASH_PLUGDIR}" ]]; then
        eprintf --error "BASH_PLUGDIR is not set"
        return 1
    fi

    mkdir_if_not_exists "${BASH_PLUGDIR}"
    __blesh_init__
}

# plugin hooks for the very end of bashrc
function __plugins_finalize__() {
    __blesh_finalize__
}
