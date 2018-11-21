#!/bin/bash

for dir in ./straps/*/ ; do
    dir=${dir##*./straps/}
    dir=${dir%*/}
    shasum -a 256 "straps/${dir}/${dir}.sh" > "straps/${dir}/${dir}.sh.DIGEST"
done
