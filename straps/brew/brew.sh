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

    for (( i=tap_count; i>0; i-- )); do
        tap=$(yq read "${1}" -j | jq -r ".brew.tap[${i}-1].name")
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done

    for (( i=pkg_count; i>0; i-- )); do
        pkg=$(yq read "${1}" -j | jq -r ".brew.package[${i}-1].name")
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done

    for (( i=cask_count; i>0; i-- )); do
        pkg=$(yq read "${1}" -j | jq -r ".brew.cask[${i}-1].name")
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_after () { 
    return 
}


