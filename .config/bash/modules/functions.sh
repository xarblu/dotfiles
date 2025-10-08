# misc functions for interactive sessions

# wrapper around cmake to do a full build
function cmake-it() {
    if [[ ! -f ../CMakeLists.txt ]]; then
        eprintf --error "Parent directory does not contain CMakeLists.txt\n"
        return 1
    fi

    if ! cmake \
        -DCMAKE_C_COMPILER="${CC:-clang}" \
        -DCMAKE_CXX_COMPILER="${CXX:-clang++}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        ..
    then
        eprintf --error "cmake configure failed\n"
        return 1
    fi

    if ! cmake \
        --build . \
        -- \
        -j"$(nproc)"
    then
        eprintf --error "cmake build failed\n"
        return 1
    fi
}

# create a directory and cd into it
function mkcd() {
    if (( ${#} != 1 )); then
        eprintf --error "usage: <directory>\n"
        return 1
    fi

    local dir="$1"

    if ! mkdir -p "${dir}"; then
        eprintf --error "Creating ${dir} failed\n"
        return 1
    fi

    if ! cd "${dir}"; then
        eprintf --error "Could not change into ${dir}\n"
        return 1
    fi
}

function fix-jf-media-permissions() {
    if (( ${#} != 1 )); then
        eprintf --error "usage: <directory>\n"
        return 1
    fi

    local library="${1}"
    local sudo="${SUDO:-sudo}"

    if [[ ! -d "${library}" ]]; then
        eprintf --error "Library does not exist: ${library}\n"
        return 1
    fi

    eprintf --info "Fixing permissions of library: ${library}\n"

    eprintf --info "Changing owner to root:root\n"
    ${sudo} chown -R root:root "${library}"

    eprintf --info "Changing directory mode to 755\n"
    ${sudo} find "${library}" -type d -exec chmod 755 '{}' +

    eprintf --info "Changing file mode to 644\n"
    ${sudo} find "${library}" -type f -exec chmod 644 '{}' +
}

function cat-now() {
    has_cmds curl jq xargs viu || return 1
    curl -s 'https://api.thecatapi.com/v1/images/search' | jq -r '.[0]["url"]' | xargs -n1 curl -s | TERM=xterm viu -
}
