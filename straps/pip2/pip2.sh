#!/bin/bash
strapped_pip2_before () { 
    if ! pip -V > /dev/null; then echo "🐍 pip is missing" && exit; fi 
}

strapped_pip2 () {
    local pip2_count
    local pkg
    
    pip2_count=$(yq read "${1}" -j | jq -r '.pip2.packages | length')

    for (( i=0; i < pip2_count; i++ )); do
        pkg=$(yq read "${1}" -j | jq -r ".pip2.packages[${i}].name")
        echo "🐍 installing ${pkg}"
        pip install "${pkg}"
    done
}

strapped_pip2_after () { 
    return
}


