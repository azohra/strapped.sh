#!/bin/bash
set -euo pipefail

raw_strap_url="https://raw.githubusercontent.com/azohra/strapped.sh/main/straps"
docs_location="_static/_docs"
generated_docs="${docs_location}/straps"

[ "${generated_docs}" = "_static/_docs/straps" ] || { echo "docs: refusing — generated path is unexpected" >&2; exit 1; }
[ -d "${docs_location}" ] || { echo "docs: refusing — ${docs_location} is missing" >&2; exit 1; }
rm -rf "${generated_docs}"
mkdir "${generated_docs}"

base="[![logo](https://raw.githubusercontent.com/azohra/strapped.sh/main/_static/img/logo-black.png)](https://strapped.azohra.com)

- [Home](/)
- [Guide](README.md)

- Straps"

echo "$base" > "${docs_location}/_sidebar.md"

# Make each doc file and embed the source documentation
for dir in ./straps/*/ ; do
    dir=${dir##*./straps/}
    dir=${dir%*/}
    echo "[Build] linking documentation for ${dir}"
    echo "[$dir](${raw_strap_url}/${dir}/latest/README.md ':include')" > "${generated_docs}/$dir.md"
    echo "  - [${dir}](straps/${dir}.md)" >> "${docs_location}/_sidebar.md"
done
