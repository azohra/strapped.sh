#!/bin/bash
strapped_pip2_before () { 
    if ! pip -V > /dev/null; then echo "🐍 pip is missing" && exit; fi 
}

strapped_pip2 () {
    local pip2_count
    local pkg
    
    pip2_count=$(jq -r '.pip2.packages | length' <<< "${1}")

    for (( i=0; i < pip2_count; i++ )); do
        pkg=$(jq -r ".pip2.packages[${i}].name" <<< "${1}")
        echo "🐍 installing ${pkg}"
        pip install "${pkg}"
    done
}

strapped_pip2_after () { 
    return
}


