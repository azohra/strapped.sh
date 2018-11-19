#!/bin/bash
set -e
strapped_git_before () { 
    if ! git --version > /dev/null; then echo "💾 git is missing" && exit; fi 
}

strapped_git () {

    local repos
    local folder
    
    repos=$(yq read "${1}" -j | jq -r '.git.clone[].repo')

    for repo in ${repos}; do
        folder=$(yq read "${1}" -j | jq -r ".git.clone[${i}-1].folder")
        echo "💾 cloning ${repo} into ${folder}"
        if [ ! -d "${folder}" ] ; then git clone "${repo}" "${folder}"; fi
    done
}

strapped_git_after () { 
    return
}
