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
}
