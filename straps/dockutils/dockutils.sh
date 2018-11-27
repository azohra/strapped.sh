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
    local user_config=$1
    local position
    local display
    local sort
    local view

    app_count=$(q_count "$user_config" "apps.\\[[0-9]+\\].name")
    dir_count=$(q_count "$user_config" "dirs.\\[[0-9]+\\].path")

    dockutil --remove all --no-restart
    
    for (( i=0; i < app_count; i++ )); do
        path=$(q "$user_config" "apps.\\[${i}\\].path")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --no-restart
    done

    for (( i=0; i < app_count; i++ )); do
        name=$(q "$user_config" "apps.\\[${i}\\].name")
        position=$(q "$user_config" "apps.\\[${i}\\].position")
        echo "🛳️  moving ${name} to position ${position}"
        dockutil --move "${name}" --position "${position}" --no-restart
    done

    for (( i=0; i < dir_count; i++ )); do
        path=$(q "$user_config" "dirs.\\[${i}\\].path")
        view=$(q "$user_config" "dirs.\\[${i}\\].view")
        display=$(q "$user_config" "dirs.\\[${i}\\].display")
        sort=$(q "$user_config" "dirs.\\[${i}\\].sort")

        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
    done
}

strapped_dockutils_after () { 
    killall -KILL Dock 
}
