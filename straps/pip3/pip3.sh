#!/bin/bash
strapped_pip3_before () { 
    if ! pip3 -V > /dev/null; then echo "🐍 pip3 is missing" && exit; fi 
}

strapped_pip3 () {
    local pip3_count
    local pkg
    local user_json

    user_json=$1    
    pip3_count=$(jq -r '.packages | length' <<< "$user_json")

    for (( i=0; i < pip3_count; i++ )); do
        pkg=$(jq -r ".packages[${i}].name" <<< "$user_json")
        echo "🐍 installing ${pkg}"
        pip3 install "${pkg}"
    done
}

strapped_pip3_after () { 
    return
}


