#[START] Important Dirs
export ZDATADIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh"
if [[ ! -d "${ZDATADIR}" ]]; then
	echo "ZDATADIR doesn't exist!"
	printf "Create at ${ZDATADIR}? [y/N]: "
	if read -q; then
		echo
		mkdir -p "${ZDATADIR}"
	fi
fi
#[END] Important Dirs

#[START] Shell Options
unsetopt BEEP
setopt AUTO_CD 
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt EXTENDED_GLOB
setopt AUTO_CONTINUE

#ZSH History
export HISTFILE="${ZDATADIR}/history"
export HISTSIZE=100000
export SAVEHIST=100000
# create histfile if needed
if [[ ! -f "${HISTFILE}" ]]; then
    touch "${HISTFILE}"
fi
#[END] Shell Options

#[START] Eyecandy
#Custom Prompt & colours (in case starship isn't installed)
autoload -Uz colors && colors
PS1="%(?.%F{green}[✓].%F{red}[%?])%f %F{27}%n@%m%f %B%F{22}%~%f%b %B%#%b"$'\n'"%B%F{81}»%f%b "

case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|alacritty|interix|tmux*|wezterm)
		# Set terminal title for running processes
		function precmd {
			printf "\033]0;zsh\007"
		}
		function preexec {
            # $2 is cmd with very long args stripped
            # TODO: compare with $3 to add ... indicators
            printf "\033]0;${2}\007"
		}
		# Dynamically change cursor style
		function zle-line-init zle-line-finish zle-keymap-select {
		    case ${KEYMAP} in
		        # Blinking block cursor.
		        vicmd|visual) print -n '\e[1 q';;
			# Blinking bar cursor.
		        *)            print -n '\e[5 q';;
		    esac
		}
		zle -N zle-line-init
		zle -N zle-line-finish
		zle -N zle-keymap-select
		;;
esac
#[END] Eyecandy

#[START] Helpers
# echo to stderr
function err() {
    echo "${@}" 1>&2
}

# check if $1 is a command that exists
function has_cmd() {
    if [[ ${#} -ne 1 ]]; then
        err "has_cmd() takes only 1 arg"
        return 1
    fi
    command -v "${1}" >/dev/null
    return ${?}
}
#[END] Helpers

#[START] Keybinds
#Use Emacs Keybinds
bindkey -e
#Custom Keybinds
bindkey '^[[1;5A' beginning-of-line # ctrl+up
bindkey '^[[1;5B' end-of-line # ctrl+down
bindkey '^[[1;5C' forward-word # ctrl+right
bindkey '^[[1;5D' backward-word # ctrl+left
bindkey '^H' backward-delete-word # ctrl+backspace
#[END] Keybinds

#[START] Aliases & Functions
if [[ -f ${ZDOTDIR}/aliasrc ]]; then
	source ${ZDOTDIR}/aliasrc
fi
if [[ -f ${ZDOTDIR}/functionrc ]]; then
	source ${ZDOTDIR}/functionrc
fi
#[END] Aliases & Functions

#[START] Secrets
if [[ -f ${ZDOTDIR}/.secrets ]]; then
	source ${ZDOTDIR}/.secrets
fi
#[END] Secrets

#[START] FFMPEG PROFILES
if [[ -f ${FFMPEG_DATADIR:=${XDG_DATA_HOME:-${HOME}/.config/ffmpeg}/ffmpeg}/ffmpeg-arg-bundles.sh ]]; then
	source ${FFMPEG_DATADIR:=${XDG_DATA_HOME:-${HOME}/.config/ffmpeg}/ffmpeg}/ffmpeg-arg-bundles.sh
fi
#[END] FFMPEG PROFILES

#[START] Zinit Plugin Section
if [[ -f ${ZDOTDIR}/zinitrc ]]; then
	source ${ZDOTDIR}/zinitrc
fi
#[END] Zinit Plugin Section

#[START] Completions
autoload -Uz compinit && compinit
zstyle ':completion:*' file-patterns '%p(D):globbed-files *(D-/):directories' '*(D):all-files' #Include Hidded Files
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ""
autoload -Uz bashcompinit && bashcompinit
if [[ -n "$(command -v register-python-argcomplete)" ]] && [[ -n "$(command -v pipx)" ]]; then
	eval "$(register-python-argcomplete --shell zsh pipx)"
fi
# reload previously cached completions from zinit
if [[ -n "$(command -v zinit)" ]]; then
    zinit cdreplay -q
fi
#[END] Completions

#[START] External Utils
#lauch tmux if it is available and not launched already
if has_cmd tmux; then
    if [[ -z "${TMUX}" ]] && [[ "$(hostname)" == ServiceableServer ]]; then 
    		tmux
    		exit
	fi
fi

#Use thefuck if available
if has_cmd thefuck; then
	eval $(thefuck --alias)
fi

#Use Starship Prompt if available
if has_cmd starship; then
	eval "$(starship init zsh)"
fi

#Use eza if available, else use regular ls with some flags
if has_cmd eza; then
	alias ls="eza -lag --icons --git --color=auto --group-directories-first"
else
    alias ls="ls -lah --color=auto --group-directories-first"
fi

#Use rmtrash if available
if has_cmd rmtrash; then
	alias rm="rmtrash -I"
fi
if has_cmd rmdirtrash; then
	alias rmdir="rmdirtrash"
fi

#broot launcher
if [[ -f ${XDG_CONFIG_HOME:=${HOME}/.config}/broot/launcher/bash/br ]] && has_cmd broot; then
	source ${XDG_CONFIG_HOME:=${HOME}/.config}/broot/launcher/bash/br
fi

# select manpager
if has_cmd nvim; then
    export MANPAGER='nvimpager +Man!'
    export MANWIDTH='999'
elif has_cmd bat; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# zoxide as cd
if has_cmd zoxide; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# goldwarden ssh agent
if [[ -S "${HOME}/.goldwarden-ssh-agent.sock" ]]; then
    export SSH_AUTH_SOCK="${HOME}/.goldwarden-ssh-agent.sock"
fi

#And finally a fastfetch (if available)
if has_cmd fastfetch; then
	fastfetch
fi
#[END] External Utils

