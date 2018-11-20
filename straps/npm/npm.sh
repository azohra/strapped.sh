#!/bin/bash
strapped_npm_before () { 
    if ! npm -v > /dev/null; then echo "☕ npm is missing" && exit; fi 
}

strapped_npm () {
    local npm_count
    local pkg
    
    npm_count=$(yq read "${1}" -j | jq -r '.npm.packages | length')

    for (( i=0; i < npm_count; i++ )); do
        pkg=$(yq read "${1}" -j | jq -r ".npm.packages[${i}].name")
        echo "☕ installing ${pkg}"
        npm install -g "${pkg}"
    done
}

strapped_npm_after () { 
    return
}
