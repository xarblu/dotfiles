#before anything else happens re-source /etc/profile defaults
source /etc/profile

#Shell
export SHELL=/bin/zsh

#Locale
export LANG=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

#stop ksshaskpass from popping up
unset SSH_ASKPASS

#Compilers 'n stuff
export CC="clang"
export CXX="clang++"
export CPP="clang-cpp"
export LD="ld.lld"
export AR="llvm-ar"
export NM="llvm-nm"
export RANLIB="llvm-ranlib"
export CXXSTDLIB="c++"
#(s)ccache
export RUSTC_WRAPPER="/usr/bin/sccache"
export SCCACHE_MAX_FRAME_LENGTH="104857600"
export SCCACHE_DIR="${XDG_CACHE_HOME:=${HOME}/.cache}/sccache"
export USE_CCACHE="1"
export CCACHE_EXEC="/usr/bin/ccache"
export CCACHE_DIR="${XDG_CACHE_HOME:=${HOME}/.cache}/ccache"

#Have zstd use all available threads if called
export ZSTD_NBTHREADS=0
export ZSTD_CLEVEL=10

#GPG fails wihhout this variable set
GPG_TTY=$(tty)
export GPG_TTY

#set caca driver to slang to render inside terminal
export CACA_DRIVER=slang
