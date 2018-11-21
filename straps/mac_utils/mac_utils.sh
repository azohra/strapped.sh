#!/bin/bash

strapped_mac_utils_before () { 
  return
}

strapped_mac_utils () {
  local m_u_count

  m_u_count=$(jq -r '.mac_utils.plists | length' <<< "${1}")

  for (( i=0; i < m_u_count; i++ )); do
      domain=$(jq -r ".mac_utils.plists[${i}].domain" <<< "${1}")
      key=$(jq -r ".mac_utils.plists[${i}].key" <<< "${1}")
      type=$(jq -r ".mac_utils.plists[${i}].type" <<< "${1}")
      value=$(jq -r ".mac_utils.plists[${i}].value" <<< "${1}")
      echo "🛠️ Updating ${domain} ${key} to ${value}"
      plutil -replace "${key}" -"${type}" "${value}" ~/Library/Preferences/"${domain}".plist
  done
}

strapped_mac_utils_after () { 
  return   
}
