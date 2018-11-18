#!/bin/bash
strapped_npm_before () { 
    if ! npm -v > /dev/null; then echo "☕ npm is missing" && exit; fi 
}

strapped_npm () {
    
    local pkgs
    
    pkgs=$(yq read "${1}" -j | jq -r '.npm[]')
    
    for pkg in ${pkgs}; do
        echo "☕ installing ${pkg}"
        npm install -g "${pkg}"
    done
}

strapped_npm_after () { 
    return
}


