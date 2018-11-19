#!/bin/bash

# Raw strap url
raw_strap_url="https://raw.githubusercontent.com/azohra/strapped/master/straps"

# Delete and make a new _docs/straps folder
rm -rf _docs/straps
mkdir _docs/straps

base="![logo](https://raw.githubusercontent.com/azohra/strapped/master/img/logo-black.png)

- [Home](/)
- [Guide](README.md)

- Straps"

echo "$base" > _docs/_sidebar.md

# Make each doc file and embed the source documentation
for dir in `ls straps/`; do
    echo "[Build] linking documentation for $dir"
    echo "[$dir]($raw_strap_url/$dir/README.md \":include\")" > _docs/straps/$dir.md
    echo "  - [$dir](straps/$dir.md)" >> _docs/_sidebar.md
done
