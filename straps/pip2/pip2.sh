#!/bin/bash
strapped_pip2_before () { 
    if ! pip -V > /dev/null; then echo "🐍 pip is missing" && exit; fi 
}

strapped_pip2 () {
    local pip2_count
    local pkg
    local user_config=$1
 
    pip2_count=$(q_count "$user_config" "packages.\\[[0-9]+\\].name")

    for (( i=0; i < pip2_count; i++ )); do
        pkg=$(q "$user_config" "packages.\\[${i}\\].name")
        echo "🐍 (2.x.x) installing ${pkg}"
        pip install "${pkg}" >/dev/null
    done
}

strapped_pip2_after () { 
    return
}
