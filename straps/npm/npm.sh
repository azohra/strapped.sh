#!/bin/bash
strapped_npm_before () { 
    if ! npm -v > /dev/null; then echo "☕ npm is missing" && exit; fi 
}

strapped_npm () {
    local npm_count
    local pkg
    
    npm_count=$(jq -r '.packages | length' <<< "${1}")

    for (( i=0; i < npm_count; i++ )); do
        pkg=$(jq -r ".packages[${i}].name" <<< "${1}")
        echo "☕ installing ${pkg}"
        npm install -g "${pkg}"
    done
}

strapped_npm_after () { 
    return
}
