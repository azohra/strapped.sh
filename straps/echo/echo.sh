#!/bin/bash
strapped_echo_before () { 
    return 
}

strapped_echo () {

    local count
    local phrase
    
    count=$(yq read "${1}" -j | jq -r '.echo | length')
    
    for i in $(seq 1 "${count}"); do
        phrase=$(yq read "${1}" -j | jq -r ".echo[${i}-1]")
        echo -e "🗣️  ${phrase}"
    done
}

strapped_echo_after () { 
    return 
}
