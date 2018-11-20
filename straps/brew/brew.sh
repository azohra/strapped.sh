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

    tap_count=$(yq read "${1}" -j | jq -r '.brew.tap | length')
    pkg_count=$(yq read "${1}" -j | jq -r '.brew.package | length')
    cask_count=$(yq read "${1}" -j | jq -r '.brew.cask | length')

    for (( i=0; i < tap_count; i++ )); do
        tap=$(yq read "${1}" -j | jq -r ".brew.tap[${i}].name")
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done

    for (( i=0; i < pkg_count; i++ )); do
        pkg=$(yq read "${1}" -j | jq -r ".brew.package[${i}].name")
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done

    for (( i=0; i < cask_count; i++ )); do
        pkg=$(yq read "${1}" -j | jq -r ".brew.cask[${i}].name")
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_after () { 
    return 
}


