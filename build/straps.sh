#!/bin/bash

for strap in ./straps/*/ ; do
  strap=${strap##*./straps/}
  strap=${strap%*/}
  echo "[Build] creating strap for ${strap}"
  ret=$(./build/compiler.sh "straps/${strap}/spec.yml")
  
  if [[ ${ret} ]]; then
    echo "${ret}"
    exit 1
  fi
done
