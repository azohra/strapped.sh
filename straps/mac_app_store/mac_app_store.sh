#!/bin/bash

strapped_mac_app_store_before () { 
    if ! mas version > /dev/null; then echo "🍏 mas is missing" && exit; fi 
}

strapped_mac_app_store () {
    local mas_count
    local user_json

    user_json=$1
    mas_count=$(jq -r '.apps | length' <<< "$user_json")

    for (( i=0; i < mas_count; i++ )); do
        name=$(jq -r ".apps[${i}].name" <<< "$user_json")
        id=$(jq -r ".apps[${i}].id" <<< "$user_json")
        echo "🍏 installing ${name}"
        mas install "${id}"
    done
}

strapped_mac_app_store_after () { 
  return   
}
