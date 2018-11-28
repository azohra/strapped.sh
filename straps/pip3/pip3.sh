#!/bin/bash
strapped_pip3_before () { 
    if ! pip3 -V > /dev/null; then echo "🐍 pip3 is missing" && exit; fi 
}

strapped_pip3 () {
    local pip3_count
    local pkg
    local user_config=$1

    pip3_count=$(q_count "$user_config" "packages")

    for (( i=0; i < pip3_count; i++ )); do
        pkg=$(q "$user_config" "packages.\\[${i}\\].name")
        echo "🐍 (3.x.x) installing ${pkg}"
        pip3 install "${pkg}" >/dev/null
    done
}

strapped_pip3_after () { 
    return
}


