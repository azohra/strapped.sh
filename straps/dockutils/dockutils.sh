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

    for (( i=app_count; i>0; i-- )); do
        path=$(yq read "${1}" -j | jq -r ".dockutils.apps[${i}-1].path")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --no-restart
    done

    for (( i=app_count; i>0; i-- )); do
        name=$(yq read "${1}" -j | jq -r ".dockutils.apps[${i}-1].name")
        position=$(yq read "${1}" -j | jq -r ".dockutils.apps[${i}-1].pos")
        echo "🛳️  moving ${name} to position ${position}"
        dockutil --move "${name}" --position "${position}" --no-restart
    done

    for (( i=dir_count; i>0; i-- )); do
        path=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}-1].path")
        view=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}-1].view")
        display=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}-1].display")
        sort=$(yq read "${1}" -j | jq -r ".dockutils.dirs[${i}-1].sort")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
    done


}

strapped_dockutils_after () { 
    killall -KILL Dock 
}



