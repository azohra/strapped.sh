#!/bin/bash
strapped_pip2_before () { 
    if ! pip -V > /dev/null; then echo "🐍 pip is missing" && exit; fi 
}

strapped_pip2 () {
    local pip2_count
    local pkg
    local user_json

    user_json=$1   
    pip2_count=$(jq -r '.packages | length' <<< "$user_json")

    for (( i=0; i < pip2_count; i++ )); do
        pkg=$(jq -r ".packages[${i}].name" <<< "$user_json")
        echo "🐍 installing ${pkg}"
        pip install "${pkg}"
    done
}

strapped_pip2_after () { 
    return
}


