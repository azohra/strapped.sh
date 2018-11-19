#!/bin/bash
strapped_pip3_before () { 
    if ! pip3 -V > /dev/null; then echo "🐍 pip3 is missing" && exit; fi 
}

strapped_pip3 () {

    local pkgs
    
    pkgs=$(yq read "${1}" -j | jq -r '.pip3[]')
    
    for pkg in ${pkgs}; do
        echo "🐍 installing ${pkg}"
        pip3 install "${pkg}"
    done
}

strapped_pip3_after () { 
    return
}


