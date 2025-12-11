# hooks called when we're inside a container
function __containers_init__() {
    case "${CONTAINER_ID}" in
        jazzy) __containers_init_jazzy__ ;;
    esac
}

# hook for ros2 "jazzy" container
function __containers_init_jazzy__() {
    local setup="/opt/ros/jazzy/setup.bash"
    if [[ -f "${setup}" ]]; then
        # shellcheck disable=SC1090
        source "${setup}"
    else
        log --error "Setup script does not exist at %s" "${setup}"
    fi

    local gz_wrapper="/usr/local/bin/gz"
    if [[ ! -x "${gz_wrapper}" ]]; then
        log --info "Installing gz (gazebo) wrapper at %s" "${gz_wrapper}"
        "${SUDO:-sudo}" tee "${gz_wrapper}" <<EOF
#!/usr/bin/env bash
export QT_QPA_PLATFORM=wayland
export PATH="\${PATH//\\/usr\\/local\\/bin:/}"
exec gz "\${@}"
EOF
        "${SUDO:-sudo}" chmod +x "${gz_wrapper}"
    fi

    export PATH="/usr/local/bin${PATH:+:}${PATH}"
}
