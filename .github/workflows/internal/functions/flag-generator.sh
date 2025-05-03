# shellcheck disable=all

set -eu

DIST_DIR="$1"
VARIANT="$(basename "${DIST_DIR}")"
WORKING_DIRECTORY="$(dirname "$0")/.."

CONFIG_PATHS=(
    "${DIST_DIR}/config"
    "${DIST_DIR}/config/internal"
    "${DIST_DIR}/config/library"
    "./pkgconfig"
)

CONFIG_PATHS="${CONFIG_PATHS[@]}"
CONFIG_PATHS="${CONFIG_PATHS// /:}"

PKG_CONFIG_PATH="${CONFIG_PATHS}"
export PKG_CONFIG_PATH

"${WORKING_DIRECTORY}/tools/pkgconf.sh"

function gen-flags() {
    local flags
    local libs

    flags=($(pkgconf --define-variable="install_dir=\${install_dir}" --cflags "$@" | tr ' ' '\n' | sort -u))
    libs=($(pkgconf --define-variable="install_dir=\${install_dir}" --libs "$@"))

    echo "${flags[@]} ${libs[@]}"
}
