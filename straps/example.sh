#!/bin/bash
strapped_example_before () { 
    return 
}

strapped_example () {

    local item
    
    item=$(yq read "${1}" -j | jq -r '.example[]')
    
    echo -e "😎 ${item}"
}

strapped_example_after () { 
    return 
}


