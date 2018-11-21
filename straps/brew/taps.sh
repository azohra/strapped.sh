#!/bin/bash
strapped_brew_before () { 
    if ! brew -v > /dev/null; then echo "🍺 brew missing" && exit; fi 
}

strapped_brew () {
    local tap_count
    local tap
    tap_count=$(jq -r ".brew.taps | length" <<< ${1})

    for (( i=0; i < tap_count; i++ )); do
        tap=$(jq -r ".brew.taps[${i}].name" <<< ${1})
        echo "🚰 tapping ${tap}"
        brew tap "${tap}"
    done
}

strapped_brew_after () { 
    return 
}


