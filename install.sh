#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# Cargo fingerprints for two Git revisions of an identically versioned binary
# can collide when the caller reuses one installation target directory.
build=$(mktemp -d)
trap 'rm -rf -- "$build"' EXIT
export CARGO_TARGET_DIR="$build"
while read -r package repository revision; do
    cargo +1.95.0 install --locked --git "https://github.com/chrono-harness/$repository.git" \
        --rev "$revision" "$package" </dev/null
done < "$root/tools.lock"
