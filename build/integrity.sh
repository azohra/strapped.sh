#!/bin/bash

for dir in ./straps/*/ ; do
    dir=${dir##*./straps/}
    dir=${dir%*/}
    shasum -a 256 "straps/${dir}/latest/${dir}.sh" > "straps/${dir}/latest/${dir}.sh.DIGEST"
done
