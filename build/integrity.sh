#!/bin/bash
echo "straps:" > straps/integrity.yml

# Make each doc file and embed the source documentation
for dir in `ls straps/`; do
    if [[ ${dir} = "integrity.yml" ]]; then continue; fi
    sha=`shasum -a 256 straps/$dir/$dir.sh`
    echo "[Build] generating SHA256 for $dir"
    echo "  $dir: \"$sha\"" >> straps/integrity.yml
done
