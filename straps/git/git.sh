#!/bin/bash
set -e
strapped_git_before () {
    if ! git --version > /dev/null; then echo "💾 git is missing" && exit; fi 
}

strapped_git () {
    local clone_count
    local folder
    local repo
    local user_config=$1

    clone_count=$(q_count "$user_config" "clone")

    for (( i=0; i < clone_count; i++ )); do
        repo=$(q "$user_config" "clone.\\[${i}\\].repo")
        folder=$(q "$user_config" "clone.\\[${i}\\].folder")
        echo "💾 cloning ${repo} into ${folder}"
        if [ ! -d "${folder}" ] ; then git clone "${repo}" "${folder}"; fi
    done
}

strapped_git_after () {
    return
}
