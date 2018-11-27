#!/bin/bash
strapped_npm_before () { 
    if ! npm -v > /dev/null; then echo "☕ npm is missing" && exit; fi 
}

strapped_npm () {
    local npm_count
    local pkg
    local user_config=$1

    npm_count=$(q_count "$user_config" "packages")

    for (( i=0; i < npm_count; i++ )); do
        pkg=$(q "$user_config" "packages.\\[${i}\\].name")
        echo "☕ installing ${pkg}"
        npm install -g "${pkg}" >/dev/null
    done
}

strapped_npm_after () { 
    return
}
