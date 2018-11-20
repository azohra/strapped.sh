#!/bin/bash
strapped_dockutils_before () { 
    if ! dockutil --version > /dev/null; then echo "🛳️ dockutil missing" && exit; fi 
}

strapped_dockutils () {  
    local app_count
    local dir_count
    local path
    local name
    local position

    app_count=$(yq read "${1}" -j | jq -r '.dockutils.apps | length')
    dir_count=$(yq read "${1}" -j | jq -r '.dockutils.dirs | length')

    dockutil --remove all --no-restart

    for (( i=0; i < app_count; i++ )); do
        path=$(yq read "${1}" -j | jq -r ".dockutils.apps[${i}].path")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --no-restart
    done

    for (( i=0; i < app_count; i++ )); do
        name=$(yq read "${1}" -j | jq -r ".dockutils.apps[${i}].name")
        position=$(yq read "${1}" -j | jq -r ".dockutils.apps[${i}].pos")
        echo "🛳️  moving ${name} to position ${position}"
        dockutil --move "${name}" --position "${position}" --no-restart
    done

    for (( i=0; i < dir_count; i++ )); do
        path=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}].path")
        view=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}].view")
        display=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}].display")
        sort=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}-.sort")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
    done


}

strapped_dockutils_after () { 
    killall -KILL Dock 
}



