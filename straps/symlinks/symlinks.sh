#!/bin/bash
strapped_symlinks_before () { 
   return
}

strapped_symlinks () {

    local count
    
    count=$(yq read "${1}" -j | jq -r '.symlinks | length')

    for i in $(seq 1 "${count}"); do
        src=$(yq read "${1}" -j | jq -r ".symlinks[${i}-1].src")
        dest=$(yq read "${1}" -j | jq -r ".symlinks[${i}-1].dest")
        echo "🔗 linking ${src} to ${dest}"
        ln -snf "${src}" "${dest}"
    done
}

strapped_symlinks_after () { 
    return 
}


