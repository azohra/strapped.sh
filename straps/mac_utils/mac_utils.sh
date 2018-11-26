#!/bin/bash

strapped_mac_utils_before () { 
  return
}

strapped_mac_utils () {
  local m_u_count
  local user_json

  user_json=$1
  m_u_count=$(jq -r '.plists | length' <<< "$user_json")

  for (( i=0; i < m_u_count; i++ )); do
      domain=$(jq -r ".plists[${i}].domain" <<< "$user_json")
      key=$(jq -r ".plists[${i}].key" <<< "$user_json")
      type=$(jq -r ".plists[${i}].type" <<< "$user_json")
      value=$(jq -r ".plists[${i}].value" <<< "$user_json")
      echo "🛠️ Updating ${domain} ${key} to ${value}"
      plutil -replace "${key}" -"${type}" "${value}" ~/Library/Preferences/"${domain}".plist
  done
}

strapped_mac_utils_after () { 
  return   
}
