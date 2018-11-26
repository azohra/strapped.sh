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
    local user_json

    user_json=$1
    app_count=$(jq -r '.apps | length' <<< "$user_json")
    dir_count=$(jq -r '.dirs | length' <<< "$user_json")

    dockutil --remove all --no-restart

    for (( i=0; i < app_count; i++ )); do
        path=$(jq -r ".apps[${i}].path" <<< "$user_json")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --no-restart
    done

    for (( i=0; i < app_count; i++ )); do
        name=$(jq -r ".apps[${i}].name" <<< "$user_json")
        position=$(jq -r ".apps[${i}].pos" <<< "$user_json")
        echo "🛳️  moving ${name} to position ${position}"
        dockutil --move "${name}" --position "${position}" --no-restart
    done

    for (( i=0; i < dir_count; i++ )); do
        path=$(jq -r ".dirs[${i}].path" <<< "$user_json")
        view=$(jq -r ".dirs[${i}].view" <<< "$user_json")
        display=$(jq -r ".dirs[${i}].display" <<< "$user_json")
        sort=$(jq -r ".dirs[${i}].sort" <<< "$user_json")
        echo "🛳️  adding ${path}"
        dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
    done


}

strapped_dockutils_after () { 
    killall -KILL Dock 
}



