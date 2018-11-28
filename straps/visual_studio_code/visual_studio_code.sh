#!/bin/bash
strapped_visual_studio_code_before () { 
    if ! code -v > /dev/null; then echo "💻 visual studio code is missing" && exit; fi 
}

strapped_visual_studio_code () {
    local ext
    local ext_count
    local user_config=$1

    ext_count=$(q_count "$user_config" "extensions")

    for (( i=0; i <ext_count; i++ )); do
        ext=$(q "$user_config" "extensions.\\[${i}\\].name")
        echo "💻 adding extension ${ext}"
        code --install-extension "${ext}"
    done
}

strapped_visual_studio_code_after () { 
    return
}
