#!/bin/bash
strapped_brew_tap_before () { 
     if ! brew -v > /dev/null; then echo "🚰 brew tap missing" && exit; fi 
}

strapped_brew_tap () {
    
    local taps
    
    taps=$(yq read "${1}" -j | jq -r '.brew_tap[]')

    for tap in ${taps}; do
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done
}

strapped_brew_tap_after () {
    return
}


