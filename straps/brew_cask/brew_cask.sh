#!/bin/bash
strapped_brew_cask_before () { 
    if ! brew -v > /dev/null; then echo "🍻 brew cask missing" && exit; fi 
}

strapped_brew_cask () {
    
    local casks

    casks=$(yq read "${1}" -j | jq -r '.brew_cask[]')
    
    for cask in ${casks}; do
        echo "🍻 installing ${cask}"
        brew cask list "${cask}" &>/dev/null || brew cask install "${cask}"
    done
}

strapped_brew_cask_after () {
    return
}


