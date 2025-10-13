#!/usr/bin/env bash

### Environment variables for bash itself

# base data directory for non-config state
BASH_DATA_DIR="${XDG_DATA_HOME:-"${HOME}/.local/share"}/bash"

# plugin directory
# shellcheck disable=SC2034
BASH_PLUGDIR="${BASH_DATA_DIR}/plugins"

# secrets file
# shellcheck disable=SC2034
BASH_SECRETS_FILE="${BASH_CONF_DIR}/.secrets"

# bash history
HISTFILE="${BASH_DATA_DIR}/history"
HISTSIZE=100000


### Exported environment variables

# local PATH
export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/npm/bin:${HOME}/.local/bin:${CARGO_HOME:-${HOME}/.cargo}/bin:${PATH}"

# stop ksshaskpass from popping up
unset SSH_ASKPASS

# compression tool defaults
export ZSTD_NBTHREADS=0
export ZSTD_CLEVEL=10
export XZ_DEFAULTS='-9 -T0'

# GPG fails without this variable set
GPG_TTY=$(tty)
export GPG_TTY

# set caca driver to slang to render inside terminal
export CACA_DRIVER=slang

# load secrets
if [[ -f "${BASH_SECRETS_FILE}" ]]; then
    # shellcheck disable=SC1090
    source -- "${BASH_SECRETS_FILE}"
fi
