#!/bin/bash
strapped_ruby_gems_before () { 
    if ! ruby -v > /dev/null; then echo "💎 ruby is missing" && exit; fi 
}

strapped_ruby_gems () {
    local gem
    local gem_count

    gem_count=$(jq -r '.ruby_gems.packages | length' <<< "${1}")
    
    for (( i=0; i < gem_count; i++ )); do
        gem=$(jq -r ".ruby_gems.packages[${i}].name" <<< "${1}")
        echo "💎 installing ${gem}"
        gem install "${gem}"
    done
}

strapped_ruby_gems_after () { 
    return
}


