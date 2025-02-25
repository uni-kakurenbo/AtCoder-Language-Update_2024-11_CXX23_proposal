# shellcheck disable=all

set -eu

DIST_DIR="$1"
VARIANT="$(basename "${DIST_DIR}")"

CONFIG_PATHS=(
    "${DIST_DIR}/config/"
    "${DIST_DIR}/config/internal/"
    "${DIST_DIR}/config/library/"
    "./pkgconfig/"

    "/opt/ac_install/lib/pkgconfig/"
)

CONFIG_PATHS="${CONFIG_PATHS[@]}"
CONFIG_PATHS="${CONFIG_PATHS// /:}"

PKG_CONFIG_PATH="${CONFIG_PATHS}"
export PKG_CONFIG_PATH

function gen-flags() {
    local flags
    local libs

    flags=($(pkg-config --define-variable="variant=${VARIANT}" --cflags "$@" | tr ' ' '\n' | sort -u))
    libs=($(pkg-config --define-variable="variant=${VARIANT}" --libs "$@"))

    echo "${flags[@]} ${libs[@]}"
}
