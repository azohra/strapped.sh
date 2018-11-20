#!/bin/bash

strapped_mac_utils_before () { 
  return
}

strapped_mac_utils () {
  local m_u_count

  m_u_count=$(yq read "${1}" -j | jq -r '.mac_utils.plist | length')

  for (( i=0; i < m_u_count; i++ )); do
      domain=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}].domain")
      key=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}].key")
      type=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}].type")
      value=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}].value")
      echo "🛠️ Updating ${domain} ${key} to ${value}"
      plutil -replace "${key}" -"${type}" "${value}" ~/Library/Preferences/"${domain}".plist
  done
}

strapped_mac_utils_after () { 
  return   
}
