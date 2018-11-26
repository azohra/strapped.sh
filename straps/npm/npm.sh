#!/bin/bash
strapped_npm_before () { 
    if ! npm -v > /dev/null; then echo "☕ npm is missing" && exit; fi 
}

strapped_npm () {
    local npm_count
    local pkg
    local user_json

    user_json=$1  
    npm_count=$(jq -r '.packages | length' <<< "$user_json")

    for (( i=0; i < npm_count; i++ )); do
        pkg=$(jq -r ".packages[${i}].name" <<< "$user_json")
        echo "☕ installing ${pkg}"
        npm install -g "${pkg}"
    done
}

strapped_npm_after () { 
    return
}
