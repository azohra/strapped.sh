#!/bin/bash
strapped_mac_app_store_before () {
    if ! mas version > /dev/null; then echo "🍏 mas is missing" && exit; fi
}

strapped_mac_app_store () {
    local mas_count
    local user_config=$1
    local name
    local id

    mas_count=$(q_count "$user_config" "apps")

    for (( i=0; i < mas_count; i++ )); do
        name=$(q "$user_config" "apps.\\[${i}\\].name")
        id=$(q "$user_config" "apps.\\[${i}\\].id")
        echo "🍏 installing ${name}"
        mas install "${id}"
    done
}

strapped_mac_app_store_after () {
  return
}
