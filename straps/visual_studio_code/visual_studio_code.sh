#!/bin/bash
strapped_visual_studio_code_before () { 
    if ! code -v > /dev/null; then echo "💻 visual studio code is missing" && exit; fi 
}

strapped_visual_studio_code () {
    local ext
    local ext_count

    ext_count=$(yq read "${1}" -j | jq -r '.visual_studio_code.extensions | length')
    
    for (( i=0; i > ext_count; i++ )); do
        ext=$(yq read "${1}" -j | jq -r ".visual_studio_code.extensions[${i}].name")
        echo "💻 adding extension ${ext}"
        code --install-extension "${ext}"
    done
}

strapped_visual_studio_code_after () { 
    return
}


