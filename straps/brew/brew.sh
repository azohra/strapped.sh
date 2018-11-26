#!/bin/bash
strapped_brew_before () { 
    if ! brew -v > /dev/null; then echo "🍺 brew missing. Would you like to install it?" && exit; fi 
}

strapped_brew () {
    local tap_count
    local pkg_count
    local cask_count

    local tap
    local pkg
    local cask
    local user_json

    user_json=$1
    tap_count=$(jq -r ".taps | length" <<< "$user_json")
    pkg_count=$(jq -r ".packages | length" <<< "$user_json")
    cask_count=$(jq -r ".casks | length" <<< "$user_json")

    for (( i=0; i < tap_count; i++ )); do
        tap=$(jq -r ".taps[${i}].name" <<< "$user_json")
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done

    for (( i=0; i < pkg_count; i++ )); do
        pkg=$(jq -r ".packages[${i}].name" <<< "$user_json")
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done

    for (( i=0; i < cask_count; i++ )); do
        cask=$(jq -r ".casks[${i}].name" <<< "$user_json")
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_after () { 
    return 
}


