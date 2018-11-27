#!/bin/bash
strapped_ruby_gems_before () { 
    if ! ruby -v > /dev/null; then echo "💎 ruby is missing" && exit; fi 
}

strapped_ruby_gems () {
    local gem
    local gem_count
    local user_config=$1

    gem_count=$(q_count "$user_config" "packages")

    for (( i=0; i < gem_count; i++ )); do
        gem=$(q "$user_config" "packages.\\[${i}\\].name")
        echo "💎 installing ${gem}"
        gem install "${gem}"
    done
}

strapped_ruby_gems_after () { 
    return
}


