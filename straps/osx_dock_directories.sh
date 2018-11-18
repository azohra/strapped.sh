#!/bin/bash
strapped_osx_dock_directories_before () { 
    if ! dockutil --version > /dev/null; then echo "🛳️ dockutil missing" && exit; fi 
}

strapped_osx_dock_directories () {

    local count 
    local path
    local view
    local display
    local sort

    count=$(yq read "${1}" -j | jq -r '.osx_dock_directories | length')
    
    for i in $(seq 1 "${count}"); do
        path=$(yq read "${1}" -j | jq -r ".osx_dock_directories[${i}-1].path")
        view=$(yq read "${1}" -j | jq -r ".osx_dock_directories[${i}-1].view")
        display=$(yq read "${1}" -j | jq -r ".osx_dock_directories[${i}-1].display")
        sort=$(yq read "${1}" -j | jq -r ".osx_dock_directories[${i}-1].sort")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
    done

}

strapped_osx_dock_directories_after () { 
    killall -KILL Dock 
}



