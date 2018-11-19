#!/bin/bash

# Raw strap url
raw_strap_url="https://raw.githubusercontent.com/azohra/strapped/master/straps"

# Delete and make a new _docs/straps folder
rm -rf _docs/straps
mkdir _docs/straps

base="[![logo](https://raw.githubusercontent.com/azohra/strapped/master/_static/img/logo-black.png)](https://strapped.sh)

- [Home](/)
- [Guide](README.md)

- Straps"

echo "$base" > _docs/_sidebar.md

echo "straps:" > strap_integrity.yml

# Make each doc file and embed the source documentation
for dir in `ls straps/`; do
    # Documentation
    echo "[Build] linking documentation for $dir"
    echo "[$dir]($raw_strap_url/$dir/README.md \":include\")" > _docs/straps/$dir.md
    echo "  - [$dir](straps/$dir.md)" >> _docs/_sidebar.md

    # Integrity
    sha=`shasum -a 256 straps/$dir/$dir.sh`
    echo "  $dir: \"$sha\"" >> strap_integrity.yml
done
