#!/bin/bash
set -e
strapped_git_before () { 
    if ! git --version > /dev/null; then echo "💾 git is missing" && exit; fi 
}

strapped_git () {
    local clone_count
    local folder
    local repo
    local user_json

    user_json=$1
    clone_count=$(jq -r '.clone | length' <<< "$user_json")
    
    for (( i=0; i < clone_count; i++ )); do
        repo=$(jq -r ".clone[${i}].repo" <<< "$user_json")
        folder=$(jq -r ".clone[${i}].folder" <<< "$user_json")
        echo "💾 cloning ${repo} into ${folder}"
        if [ ! -d "${folder}" ] ; then git clone "${repo}" "${folder}"; fi
    done
}

strapped_git_after () { 
    return
}
