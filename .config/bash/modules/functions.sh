# misc functions for interactive sessions

# wrapper around cmake to do a full build
function cmake-it() {
    if [[ ! -f ../CMakeLists.txt ]]; then
        eprintf --error "Parent directory does not contain CMakeLists.txt\n"
        return 1
    fi

    if ! cmake \
        -DCMAKE_C_COMPILER="${CC:-clang}" \
        -DCMAKE_C_FLAGS="${CC:-clang}" \
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
        return
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
