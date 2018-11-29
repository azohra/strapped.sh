#!/bin/bash

for strap in ./straps/*/ ; do
    strap=${strap##*./straps/}
    strap=${strap%*/}
    echo "[Build] creating strap for ${strap}"
    ./build/compiler.sh "straps/${strap}/spec.yml"
done

