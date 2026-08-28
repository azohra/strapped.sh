#!/bin/bash
set -euo pipefail

sources=(src/helpers.sh src/cli.sh src/main.sh)
for source in "${sources[@]}"; do
  [ -f "${source}" ] || { echo "binary: refusing — ${source} is missing" >&2; exit 1; }
done

output=$(mktemp .strapped.XXXXXX) || { echo "binary: refusing — could not create temporary output" >&2; exit 1; }
trap 'rm -f "${output}"' EXIT
cat "${sources[@]}" > "${output}"
chmod 0755 "${output}"
mv "${output}" strapped
trap - EXIT
