#!/bin/bash
strapped_ruby_gems_before () { 
    if ! ruby -v > /dev/null; then echo "💎 ruby is missing" && exit; fi 
}

strapped_ruby_gems () {

    local gems
    
    gems=$(yq read "${1}" -j | jq -r '.ruby_gems[]')
    
    for gem in ${gems}; do
        echo "💎 installing ${gem}"
        gem install "${gem}"
    done
}

strapped_ruby_gems_after () { 
    return
}


