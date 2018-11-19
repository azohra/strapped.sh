#!/bin/bash
strapped_ruby_gems_before () { 
    if ! ruby -v > /dev/null; then echo "💎 ruby is missing" && exit; fi 
}

strapped_ruby_gems () {
    local gem
    local gem_count

    gem_count=$(yq read "${1}" -j | jq -r '.ruby_gems.gems | length')
    for (( i=gem_count; i>0; i-- )); do
        gem=$(yq read "${1}" -j | jq -r ".ruby_gems.gems[${i}-1].name")
        echo "💎 installing ${gem}"
        gem install "${gem}"
    done
}

strapped_ruby_gems_after () { 
    return
}


