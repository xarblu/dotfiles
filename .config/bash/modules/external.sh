#!/usr/bin/env bash

# Setup external tools
function __external_setup__() {
    # lauch tmux if it is available and not launched already
    #if has_cmds tmux && [[ -z "${TMUX}" ]]; then
    #    tmux
    #    exit
    #fi

    # use thefuck if available
    if has_cmds thefuck; then
        eval "$(thefuck --alias)"
    fi

    # use Starship Prompt if available
    if has_cmds starship; then
        eval "$(starship init bash)"
    fi

    # use eza if available, else use regular ls with some flags
    if has_cmds eza; then
        alias ls="eza -lag --icons --git --color=auto --group-directories-first"
    else
        alias ls="ls -lah --color=auto --group-directories-first"
    fi

    # use rmtrash if available
    if has_cmds rmtrash; then
        alias rm="rmtrash -I"
    fi
    if has_cmds rmdirtrash; then
        alias rmdir="rmdirtrash"
    fi

    # broot launcher
    if [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/broot/launcher/bash/br ]] && has_cmds broot; then
        # shellcheck disable=SC1091
        source -- "${XDG_CONFIG_HOME:-"${HOME}/.config"}/broot/launcher/bash/br"
    fi

    # select manpager
    if has_cmds nvim; then
        export MANPAGER='nvim +Man! +"set nowrap"'
    elif has_cmds bat; then
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    fi

    # zoxide as cd
    if has_cmds zoxide; then
        eval "$(zoxide init bash --cmd cd)"
    fi

    # goldwarden ssh agent
    if [[ -S "${HOME}/.goldwarden-ssh-agent.sock" ]]; then
        export SSH_AUTH_SOCK="${HOME}/.goldwarden-ssh-agent.sock"
    fi

    # and finally a fastfetch (if available)
    if has_cmds fastfetch; then
        fastfetch
    fi
}
