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
    local user_config=$1

    tap_count=$(q_count "$user_config" "taps")
    pkg_count=$(q_count "$user_config" "packages")
    cask_count=$(q_count "$user_config" "casks")

    for (( i=0; i < tap_count; i++ )); do
        tap=$(q "$user_config" "taps.\\[${i}\\].name")
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done

    for (( i=0; i < pkg_count; i++ )); do
        pkg=$(q "$user_config" "packages.\\[${i}\\].name")
        echo "🍺 installing ${pkg}"
        brew list "${pkg}" &>/dev/null || brew install "${pkg}"
    done

    for (( i=0; i < cask_count; i++ )); do
        cask=$(q "$user_config" "casks.\\[${i}\\].name")
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_after () {
    return
}
