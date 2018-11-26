#!/bin/bash
strapped_visual_studio_code_before () { 
    if ! code -v > /dev/null; then echo "💻 visual studio code is missing" && exit; fi 
}

strapped_visual_studio_code () {
    local ext
    local ext_count
    local user_json

    user_json=$1
    ext_count=$(jq -r '.extensions | length' <<< "$user_json" )
    
    for (( i=0; i <ext_count; i++ )); do
        ext=$(jq -r ".extensions[${i}].name" <<< "$user_json")
        echo "💻 adding extension ${ext}"
        code --install-extension "${ext}"
    done
}

strapped_visual_studio_code_after () { 
    return
}


