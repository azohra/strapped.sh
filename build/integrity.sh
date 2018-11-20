#!/bin/bash
lock="straps:\n"
# echo "straps:" > straps/integrity.yml
initial=true
# Make each doc file and embed the source documentation
for dir in ./straps/*/ ; do
    dir=${dir##*./straps/}
    dir=${dir%*/}

    sha=($(shasum -a 256 "straps/${dir}/${dir}".sh))
    echo "[Build] generating SHA256 for $dir"
    lock+="  ${dir}: \"${sha}\"\n"
done

echo -e "${lock}" > straps/integrity.lock
