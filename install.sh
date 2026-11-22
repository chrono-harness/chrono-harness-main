#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
while read -r package repository revision; do
    cargo +1.95.0 install --locked --git "https://github.com/chrono-harness/$repository.git" \
        --rev "$revision" "$package" </dev/null
done < "$root/tools.lock"
