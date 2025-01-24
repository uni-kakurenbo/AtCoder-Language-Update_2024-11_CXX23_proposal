#!/bin/bash
set -eu

curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-full-linux-x86_64.gz |
    gzip -d - | install -m 755 /dev/stdin /usr/local/bin/taplo

taplo lint --config ./assets/taplo.toml ./dist/install.toml
