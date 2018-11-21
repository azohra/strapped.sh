#!/bin/bash
set -e
strapped_git_before () { 
    if ! git --version > /dev/null; then echo "💾 git is missing" && exit; fi 
}

strapped_git () {
    local clone_count
    local folder
    local repo
    
    clone_count=$(jq -r '.clone | length' <<< "${1}")
    
    for (( i=0; i < clone_count; i++ )); do
        repo=$(jq -r ".clone[${i}].repo" <<< "${1}")
        folder=$(jq -r ".clone[${i}].folder" <<< "${1}")
        echo "💾 cloning ${repo} into ${folder}"
        if [ ! -d "${folder}" ] ; then git clone "${repo}" "${folder}"; fi
    done
}

strapped_git_after () { 
    return
}
