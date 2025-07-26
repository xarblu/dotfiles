#!/usr/bin/env bash

# Misc extra setup
function __misc_setup__() {
    mkdir_if_not_exists "${BASH_DATADIR}"
    mkfile_if_not_exists "${HISTFILE}"
}
