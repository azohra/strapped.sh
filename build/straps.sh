#!/bin/bash

for strap in ./straps/*/ ; do
  strap=${strap##*./straps/}
  strap=${strap%*/}
  echo "[Build] creating strap for ${strap}"

  if [[ $(./build/compiler.sh "straps/${strap}/spec.yml") -ne 0 ]]; then
    exit 1
  fi
done
