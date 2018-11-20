#!/bin/bash
set -e
strapped_git_before () { 
    if ! git --version > /dev/null; then echo "💾 git is missing" && exit; fi 
}

strapped_git () {
    local clone_count
    local folder
    local repo
    
    clone_count=$(yq read "${1}" -j | jq -r '.git.clone | length')
    
    for (( i=0; i < clone_count; i++ )); do
        repo=$(yq read "${1}" -j | jq -r ".git.clone[${i}].repo")
        folder=$(yq read "${1}" -j | jq -r ".git.clone[${i}].folder")
        echo "💾 cloning ${repo} into ${folder}"
        if [ ! -d "${folder}" ] ; then git clone "${repo}" "${folder}"; fi
    done
}

strapped_git_after () { 
    return
}
