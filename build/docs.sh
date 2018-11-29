#!/bin/bash

raw_strap_url="https://raw.githubusercontent.com/azohra/strapped/master/straps"
docs_location="_static/_docs"

# Delete and make a new _docs/straps folder
rm -rf "${docs_location}/straps"
mkdir "${docs_location}/straps"

base="[![logo](https://raw.githubusercontent.com/azohra/strapped/master/_static/img/logo-black.png)](https://strapped.sh)

- [Home](/)
- [Guide](README.md)

- Straps"

echo "$base" > "${docs_location}/_sidebar.md"

# Make each doc file and embed the source documentation
for dir in ./straps/*/ ; do
    dir=${dir##*./straps/}
    dir=${dir%*/}
    echo "[Build] linking documentation for ${dir}"
    echo "[$dir](${raw_strap_url}/${dir}/latest/README.md \":include\")" > "${docs_location}/straps/$dir.md"
    echo "  - [${dir}](straps/${dir}.md)" >> "${docs_location}/_sidebar.md"
done

