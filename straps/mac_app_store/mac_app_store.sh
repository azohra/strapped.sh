#!/bin/bash

strapped_mac_app_store_before () { 
    if ! mas version > /dev/null; then echo "🍏 mas is missing" && exit; fi 
}

strapped_mac_app_store () {
    local mas_count

    mas_count=$(jq -r '.mac_app_store.apps | length' <<< ${1})

    for (( i=0; i < mas_count; i++ )); do
        name=$(jq -r ".mac_app_store.apps[${i}].name" <<< ${1})
        id=$(jq -r ".mac_app_store.apps[${i}].id" <<< ${1})
        echo "🍏 installing ${name}"
        mas install "${id}"
    done
}

strapped_mac_app_store_after () { 
  return   
}
