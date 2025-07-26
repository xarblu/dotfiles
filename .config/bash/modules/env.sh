#!/usr/bin/env bash

### Environment variables for bash itself

# base data directory for non-config state
BASH_DATADIR="${XDG_DATA_HOME:-"${HOME}/.local/share"}/bash"

# plugin directory
BASH_PLUGDIR="${BASH_DATADIR}/plugins"

# bash history
HISTFILE="${BASH_DATADIR}/history"
HISTSIZE=100000


### Exported environment variables

# local PATH
export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/npm/bin:${HOME}/.local/bin:${CARGO_HOME:-${HOME}/.cargo}/bin:${PATH}"

# locale
export LANG=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# stop ksshaskpass from popping up
unset SSH_ASKPASS

# have zstd use all available threads if called
export ZSTD_NBTHREADS=0
export ZSTD_CLEVEL=10

# GPG fails without this variable set
GPG_TTY=$(tty)
export GPG_TTY

# set caca driver to slang to render inside terminal
export CACA_DRIVER=slang
