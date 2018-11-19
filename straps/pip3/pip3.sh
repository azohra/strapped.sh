#!/bin/bash
strapped_pip3_before () { 
    if ! pip3 -V > /dev/null; then echo "🐍 pip3 is missing" && exit; fi 
}

strapped_pip3 () {
    local pip3_count
    local pkg
    
    pip3_count=$(yq read "${1}" -j | jq -r '.pip3.packages | length')

    for (( i=pip3_count; i>0; i-- )); do
        pkg=$(yq read "${1}" -j | jq -r ".pip3.packages[${i}-1].name")
        echo "🐍 installing ${pkg}"
        pip3 install "${pkg}"
    done
}

strapped_pip3_after () { 
    return
}


