#!/bin/sh
set -eu
if [ "$#" -ne 2 ]; then
    echo "usage: package.sh VERSION OUTPUT_DIRECTORY" >&2
    exit 2
fi
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
export CARGO_INSTALL_ROOT="$scratch/tools"
"$root/install.sh"
jq -Rn --arg version "$1" '
    [inputs | split(" ") | {key: .[0], value: ("bin/" + .[0])}] |
    {schema: "chrono-release-plan/v1", version: $version, assets: from_entries}
' < "$root/tools.lock" > "$scratch/plan.json"
"$CARGO_INSTALL_ROOT/bin/chrono-distribution" pack --root "$root" --asset-root "$CARGO_INSTALL_ROOT" --plan "$scratch/plan.json" --output "$2"
