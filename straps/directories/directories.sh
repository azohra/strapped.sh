#!/bin/bash
strapped_directories_before () { 
    return
}

strapped_directories () {
    
    local folders
    
    folders=$(yq read "${1}" -j | jq -r '.directories[]')
    
    for folder in ${folders}; do
        echo "📂 creating directory ${folder}"
        mkdir -p "${folder}"
    done
}

strapped_directories_after () { 
    return
}
