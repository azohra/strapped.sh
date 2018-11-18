#!/bin/bash
strapped_brew_before () { 
    if ! brew -v > /dev/null; then echo "🍺 brew missing" && exit; fi 
}

strapped_brew () {

    local pkgs
    
    pkgs=$(yq read "${1}" -j | jq -r '.brew[]')
    
    for pkg in ${pkgs}; do
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done
}

strapped_brew_after () { 
    return 
}


