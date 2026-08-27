# misc functions for interactive sessions

# sudo wrapper for the chosen sudo implementation
function sudo() {
    local sudo="${SUDO:-sudo}"
    local arg
    local sudo_args=()

    # TODO: this needs some better logic
    for arg; do
        case "${arg}" in
            -u)
                sudo_args+=( "${1}" "${2}" )
                shift 2
                ;;
            -*)
                sudo_args+=( "${1}" )
                shift 1
                ;;
            *) break ;;
        esac
    done

    # resolve to absolute path
    while [[ "${sudo:0:1}" != "/" ]]; do
        case "${sudo}" in
            sudo)
                if ! sudo="$(type -P sudo)" >/dev/null; then
                    log --error "command found: 'sudo'"
                    return 127
                fi
                ;;
            # only support a known subset
            run0|doas|pkexec)
                if ! sudo="$(type -P "${SUDO}")" >/dev/null; then
                    log --warn "chosen \${SUDO} value ${SUDO@Q} not found; trying 'sudo'"
                    sudo=sudo
                    continue
                fi

                # e.g. run0 doesn't support the "sudo VAR=val cmd" syntax so emulate it with env
                sudo_args+=( env )
                ;;
            *)
                log --error "unknown \${SUDO} value ${SUDO@Q}; trying 'sudo'"
                sudo=sudo
                ;;
        esac
    done

    "${sudo}" "${sudo_args[@]}" "${@}"
}

# wrapper around cmake to do a full build
function cmake-it() {
    if [[ ! -f ../CMakeLists.txt ]]; then
        log --error "Parent directory does not contain CMakeLists.txt"
        return 1
    fi

    if ! cmake \
        -DCMAKE_C_COMPILER="${CC:-clang}" \
        -DCMAKE_CXX_COMPILER="${CXX:-clang++}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        "${@}" \
        ..
    then
        log --error "cmake configure failed"
        return 1
    fi

    if ! cmake \
        --build . \
        -- \
        -j"$(nproc)"
    then
        log --error "cmake build failed"
        return 1
    fi
}

# create a directory and cd into it
function mkcd() {
    if (( ${#} != 1 )); then
        log --error "usage: <directory>"
        return 1
    fi

    local dir="$1"

    if ! mkdir -p "${dir}"; then
        log --error "Creating ${dir} failed"
        return 1
    fi

    if ! cd "${dir}"; then
        log --error "Could not change into ${dir}"
        return 1
    fi
}

function fix-jf-media-permissions() {
    if (( ${#} != 1 )); then
        log --error "usage: <directory>"
        return 1
    fi

    local library="${1}"

    if [[ ! -d "${library}" ]]; then
        log --error "Library does not exist: ${library}"
        return 1
    fi

    log --info "Fixing permissions of library: ${library}"

    log --info "Changing owner to root:root"
    sudo chown -R root:root "${library}"

    log --info "Changing directory mode to 755"
    sudo find "${library}" -type d -exec chmod 755 '{}' +

    log --info "Changing file mode to 644"
    sudo find "${library}" -type f -exec chmod 644 '{}' +
}

function cat-now() {
    has_cmds curl jq xargs viu || return 1
    curl -s 'https://api.thecatapi.com/v1/images/search' | jq -r '.[0]["url"]' | xargs curl -# | TERM=xterm viu -
}

# checkout last tagged released
function git-checkout-tagged() {
    local tag
    if ! tag=$(git describe --abbrev=0 origin/HEAD); then
        log --error "Failed to grab latest tag"
        return 1
    fi

    git checkout "${tag}"
}

# emerge wrapper to emerge an ebuild from the cwd
function dev-emerge() {
    if [[ ! -f ../../metadata/layout.conf ]]; then
        log --error "Not in a leaf directory of a portage tree."
        return 1
    fi

    if (( ${#} == 0 )); then
        local ebuild
        ebuild=$(find . -name '*.ebuild' -type f | sort -u | head -1)

        if [[ -z "${ebuild}" ]]; then
            log --error "Could not auto detect latest ebuild in current directory"
            return 1
        fi

        log --info 'Auto detected latest ebuild: %s' "${ebuild}"
        set -- --oneshot "${ebuild}"
    fi
    
    log --info "emerge args: %s" "${*}"

    sudo \
        FEATURES="-userpriv -usersandbox -userfetch ${FEATURES}" \
        PORTDIR_OVERLAY="../.." \
        PORTAGE_REPO_DUPLICATE_WARN="0" \
        USE="${USE}" \
        emerge "${@}"
}

function what-depends-on() {
    local pattern="${1}"

    if [[ -z "${pattern}" ]]; then
        log --error 'argument required: pattern'
    fi

    has_cmds eix xargs rg || return 1

    # TODO maybe detect repos from repos.conf
    for repo in \
            gentoo \
            guru \
            kde \
            gentoo-zh \
            xarblu-overlay \
            steam-overlay \
            haskell; do

        eix --installed-from-overlay "${repo}" --only-names \
            | xargs -rn1 qdepends \
            | rg "${pattern}" \
            | perl -p -e 's|(.*): .*|~\1|' \
            | perl -p -e 's|(kde-.*)-6.5.1|\1-6.5.2|' \
            | perl -p -e 's|.*sys-libs/zlib.*||'

    done
}

# basic default formatting for C/C++
function clang-quick-format() {
    clang-format \
        --style='{BasedOnStyle: llvm, IndentWidth: 4, ReflowComments: false}' \
        "${@}"
}

function podman-pull-all() {
    local dir="${1}"
    if [[ ! -d "${dir}" ]]; then
        log --error 'argument required: dir'
        return 1
    fi

    has_cmds perl podman xargs || return 1

    perl -n -e 'print "$1\n" if /^Image=(\S+)/' "${dir}"/*.container | sudo xargs podman pull
}

# simple tmux launcher to attach to an existing
# session if one exists or launch a new one
# no-op if already in a tmux session
# if arguments are present mirrors default behaviour
function tmux() {
    # the real tmux
    # shellcheck disable=SC2155
    local tmux="$(type -P tmux)"

    if (( ${#} > 0 )); then
        "${tmux}" "${@}"
        return
    fi

    [[ -n "${TMUX}" ]] && return

    "${tmux}" attach || "${tmux}"
}
