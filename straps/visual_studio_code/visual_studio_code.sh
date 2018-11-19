#!/bin/bash
strapped_visual_studio_code_before () { 
    if ! code -v > /dev/null; then echo "💻 visual studio code is missing" && exit; fi 
}

strapped_visual_studio_code () {

    local extensions
    
    extensions=$(yq read "${1}" -j | jq -r '.visual_studio_code.extensions[].name')
    for extension in ${extensions}; do
        echo "💻 adding extension ${extension}"
        code --install-extension "${extension}"
    done
}

strapped_visual_studio_code_after () { 
    return
}


