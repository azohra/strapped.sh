#!/bin/bash

strapped_mac_app_store_before () { 
    if ! mas version > /dev/null; then echo "🍏 mas is missing" && exit; fi 
}

strapped_mac_app_store () {
    local mas_count

    mas_count=$(yq read "${1}" -j | jq -r '.mac_app_store.apps | length')

    for (( i=0; i < mas_count; i++ )); do
        name=$(yq read "${1}" -j | jq -r ".mac_app_store.apps[${i}].name")
        id=$(yq read "${1}" -j | jq -r ".mac_app_store.apps[${i}].id")
        echo "🍏 installing ${name}"
        mas install "${id}"
    done
}

strapped_mac_app_store_after () { 
  return   
}
