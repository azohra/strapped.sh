#!/bin/bash
strapped_ruby_gems_before () { 
    if ! ruby -v > /dev/null; then echo "💎 ruby is missing" && exit; fi 
}

strapped_ruby_gems () {
    local gem
    local gem_count
    local user_json

    user_json=$1
    gem_count=$(jq -r '.packages | length' <<< "$user_json")
    
    for (( i=0; i < gem_count; i++ )); do
        gem=$(jq -r ".packages[${i}].name" <<< "$user_json")
        echo "💎 installing ${gem}"
        gem install "${gem}"
    done
}

strapped_ruby_gems_after () { 
    return
}


