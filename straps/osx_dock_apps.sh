#!/bin/bash
strapped_osx_dock_apps_before () { 
    if ! dockutil --version > /dev/null; then echo "🛳️ dockutil missing" && exit; fi 
}

strapped_osx_dock_apps () {
    
    local count
    local path
    local name
    local position

    count=$(yq read "${1}" -j | jq -r '.osx_dock_apps | length')
    
    dockutil --remove all --no-restart
    
    for i in $(seq 1 "${count}"); do
        path=$(yq read "${1}" -j | jq -r ".osx_dock_apps[${i}-1].path")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --no-restart
    done

    for i in $(seq 1 "${count}"); do
        name=$(yq read "${1}" -j | jq -r ".osx_dock_apps[${i}-1].name")
        position=$(yq read "${1}" -j | jq -r ".osx_dock_apps[${i}-1].pos")
        echo "🛳️  moving ${name} to position ${position}"
        dockutil --move "${name}" --position "${position}" --no-restart
    done
}

strapped_osx_dock_apps_after () { 
    killall -KILL Dock 
}



