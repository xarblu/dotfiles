# misc functions for interactive sessions

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
    local sudo="${SUDO:-sudo}"

    if [[ ! -d "${library}" ]]; then
        log --error "Library does not exist: ${library}"
        return 1
    fi

    log --info "Fixing permissions of library: ${library}"

    log --info "Changing owner to root:root"
    ${sudo} chown -R root:root "${library}"

    log --info "Changing directory mode to 755"
    ${sudo} find "${library}" -type d -exec chmod 755 '{}' +

    log --info "Changing file mode to 644"
    ${sudo} find "${library}" -type f -exec chmod 644 '{}' +
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
        FEATURES="-userpriv -usersandbox -userfetch" \
        PORTDIR_OVERLAY="../.." \
        PORTAGE_REPO_DUPLICATE_WARN="0" \
        USE="${USE}" \
        emerge "${@}"
}
