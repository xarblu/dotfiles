#!/usr/bin/env bash

# Misc extra setup
function __misc_setup__() {
    mkdir_if_not_exists "${BASH_DATA_DIR}"
    mkfile_if_not_exists "${HISTFILE}"
    mkfile_if_not_exists "${BASH_SECRETS_FILE}"

    # append HISTFILE on shell exit instead of overwriting
    shopt -s histappend

    # allow cd without cd
    shopt -s autocd

    # more useful interactive globs
    # match hidden files, recursive
    # and return empty if not matched
    shopt -s dotglob
    shopt -s globstar
    shopt -s nullglob
}
