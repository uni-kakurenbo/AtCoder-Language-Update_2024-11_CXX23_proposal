#!/bin/bash
set -eu

WORKING_DIRECTORY="$(dirname "$0")/.."
DIST_DIR="./dist/$1"

# shellcheck source=/dev/null
source "${WORKING_DIRECTORY}/functions/flag-generator.sh" "${DIST_DIR}"

"${WORKING_DIRECTORY}/replacers/pkg-config.sh" "${DIST_DIR}"

gen-flags ac_internal | sed -e 's/ +/ /' | tr ' ' '\n' >"${DIST_DIR}/internal.flags.txt"
gen-flags ac_pre-compile | sed -e 's/ +/ /' | tr ' ' '\n' >"${DIST_DIR}/pre-compile.flags.txt"

sed -i '/^$/d' "${DIST_DIR}/internal.flags.txt"
sed -i '/^$/d' "${DIST_DIR}/pre-compile.flags.txt"

cat "${DIST_DIR}/internal.flags.txt"
echo
cat "${DIST_DIR}/pre-compile.flags.txt"

"${WORKING_DIRECTORY}/replacers/sub-installer.sh" "${DIST_DIR}"
"${WORKING_DIRECTORY}/replacers/installer.sh" "${DIST_DIR}"

chmod +x -R ./dist/
