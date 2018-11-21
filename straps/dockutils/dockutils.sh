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

    app_count=$(jq -r '.dockutils.apps | length' <<< "${1}")
    dir_count=$(jq -r '.dockutils.dirs | length' <<< "${1}")

    dockutil --remove all --no-restart

    for (( i=0; i < app_count; i++ )); do
        path=$(jq -r ".dockutils.apps[${i}].path" <<< "${1}")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --no-restart
    done

    for (( i=0; i < app_count; i++ )); do
        name=$(jq -r ".dockutils.apps[${i}].name" <<< "${1}")
        position=$(jq -r ".dockutils.apps[${i}].pos" <<< "${1}")
        echo "🛳️  moving ${name} to position ${position}"
        dockutil --move "${name}" --position "${position}" --no-restart
    done

    for (( i=0; i < dir_count; i++ )); do
        path=$(jq -r ".dockutils.dirs[${i}].path" <<< "${1}")
        view=$(jq -r ".dockutils.dirs[${i}].view" <<< "${1}")
        display=$(jq -r ".dockutils.dirs[${i}].display" <<< "${1}")
        sort=$(jq -r ".dockutils.dirs[${i}].sort" <<< "${1}")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
    done


}

strapped_dockutils_after () { 
    killall -KILL Dock 
}



