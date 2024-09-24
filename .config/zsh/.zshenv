#before anything else happens re-source /etc/profile defaults
source /etc/profile

#Shell
export SHELL=/bin/zsh

#Path
export PATH="${XDG_DATA_HOME:-${HOME}/.local/share}/npm/bin:${HOME}/.local/bin:${CARGO_HOME}/bin:${PATH}"

#Locale
export LANG=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

#stop ksshaskpass from popping up
unset SSH_ASKPASS

#Have zstd use all available threads if called
export ZSTD_NBTHREADS=0
export ZSTD_CLEVEL=10

#GPG fails wihhout this variable set
GPG_TTY=$(tty)
export GPG_TTY

#set caca driver to slang to render inside terminal
export CACA_DRIVER=slang
