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

#[START] PATH
#Path (in .zshrc and not .zshenv cuz the latter is broken in tmux)
export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/npm/bin:${HOME}/.local/bin:${CARGO_HOME}/bin:${PATH}"
#Prepend sccache compiler wrappers
export PATH="/usr/lib/sccache/bin:${PATH}"
#[END] PATH

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
		#Set terminal title for running processes
		function precmd {
			printf "\033]0;zsh\007"
		}
		function preexec {
			declare -a local args
			for arg in $(echo ${1}); do args=( ${args[*]} ${arg} ); done
			case ${args[1]} in
				sudo|doas)
					printf "\033]0;${args[1]} ${args[2]}\007"
					;;
				*)
					printf "\033]0;${args[1]}\007"
					;;
			esac
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

#[START] External Utils
#lauch tmux if it is available and not launched already
if [[ -n "$(command -v tmux)" ]]; then
    if [[ -z "${TMUX}" ]] && [[ "$(hostname)" == ServiceableServer ]]; then 
    		tmux 
    		exit
	fi
fi

#Use thefuck if available
if [[ -n "$(command -v thefuck)" ]]; then
	eval $(thefuck --alias)
fi

#Use Starship Prompt if available
if [[ -n "$(command -v starship)" ]]; then
	eval "$(starship init zsh)"
fi

#Use eza if available
if [[ -n "$(command -v eza)" ]]; then
	EXA_FLAGS="--all --long --icons --git --color=auto --group-directories-first"
	alias ls="eza ${EXA_FLAGS}"
fi

#Use rmtrash if available
if [[ -n "$(command -v rmtrash)" ]]; then
	alias rm="rmtrash -I"
fi
if [[ -n "$(command -v rmdirtrash)" ]]; then
	alias rmdir="rmdirtrash"
fi

#broot launcher
if [[ -f ${XDG_CONFIG_HOME:=${HOME}/.config}/broot/launcher/bash/br ]] && [[ -n "$(command -v broot)" ]]; then
	source ${XDG_CONFIG_HOME:=${HOME}/.config}/broot/launcher/bash/br
fi

#Bat as (Man-)Pager
if [[ -n "$(command -v bat)" ]]; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
	#export PAGER="sh -c 'col -bx | bat -l txt -p'"
fi

#And finally a fastfetch (if available)
if [[ -n "$(command -v fastfetch)" ]]; then
	fastfetch -c paleofetch.jsonc
fi
#[END] External Utils

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

