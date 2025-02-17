#!/bin/bash
set -eu

export OUTPUT=./test/merged.test.cpp

mkdir -p ./test/
echo "" >"${OUTPUT}"

function replace() {
    local target="$1"

    local category
    category="$(basename "$(dirname "${target}")")"

    local name
    name="$(basename "${target}")"
    name="${name//.test.cpp/}"

    local tag="test_${category}_${name}"
    tag="${tag//-/_}"

    local content
    content="$(cat "${target}")"
    content="${content//int main()/"void ${tag}(int, char* [])"}"
    content="${content//int main/"void ${tag}"}"

    {
        echo
        echo "${content}"
    } | sed -E -e 's/^ +//g' | tr '\n' '\r' | sed -E -e 's/ +/ /g' -e 's/\r+/\r/g' | tr '\r' '\n' >>"${OUTPUT}"

    echo "${tag}"
}

export -f replace

MAIN="$(
    find ./test/ -iname '*.test.cpp' -print0 |
        xargs -0 -I {} bash -c "replace {}" |
        xargs -I {} echo '{}(argc, argv);'
)"

{
    echo "int main(int argc, char* argv[]) {"
    echo "${MAIN}"
    echo "}"
} >>"${OUTPUT}"
