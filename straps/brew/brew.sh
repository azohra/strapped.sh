#!/bin/bash
strapped_brew_before () { 
    if ! brew -v > /dev/null; then echo "🍺 brew missing" && exit; fi 
}

strapped_brew () {

    local taps
    local pkgs
    local casks

    taps=$(yq read "${1}" -j | jq -r '.brew.tap[].name') 
    pkgs=$(yq read "${1}" -j | jq -r '.brew.package[].name')
    casks=$(yq read "${1}" -j | jq -r '.brew.cask[].name')

    for tap in ${taps}; do
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done

    for pkg in ${pkgs}; do
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done

    for cask in ${casks}; do
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_after () { 
    return 
}


