#!/bin/bash
strapped_pip2_before () { 
    if ! pip -V > /dev/null; then echo "🐍 pip is missing" && exit; fi 
}

strapped_pip2 () {

    local pkgs
    
    pkgs=$(yq read "${1}" -j | jq -r '.pip2[]')
    
    for pkg in ${pkgs}; do
        echo "🐍 installing ${pkg}"
        pip install "${pkg}"
    done
}

strapped_pip2_after () { 
    return
}


