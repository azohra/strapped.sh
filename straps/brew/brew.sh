#!/bin/bash
strapped_brew_before () { 
    if ! brew -v > /dev/null; then echo "🍺 brew missing" && exit; fi 
}

strapped_brew () {
    local tap_count
    local pkg_count
    local cask_count
    local tap
    local pkg
    local cask
    tap_count=$(jq -r ".taps | length" <<< "${1}")
    pkg_count=$(jq -r ".packages | length" <<< "${1}")
    cask_count=$(jq -r ".casks | length" <<< "${1}")

    for (( i=0; i < tap_count; i++ )); do
        tap=$(jq -r ".taps[${i}].name" <<< "${1}")
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done

    for (( i=0; i < pkg_count; i++ )); do
        pkg=$(jq -r ".packages[${i}].name" <<< "${1}")
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done

    for (( i=0; i < cask_count; i++ )); do
        cask=$(jq -r ".casks[${i}].name" <<< "${1}")
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_after () { 
    return 
}


