#!/bin/bash

strapped_mac_utils_before () { 
  return
}

strapped_mac_utils () {
  local m_u_count
  m_u_count=$(yq read "${1}" -j | jq -r '.mac_utils.plist | length')
  for i in $(seq 1 "${m_u_count}"); do
      domain=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}-1].domain")
      key=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}-1].key")
      type=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}-1].type")
      value=$(yq read "${1}" -j | jq -r ".mac_utils.plist[${i}-1].value")
      echo "🛠️ Updating ${domain} ${key} to ${value}"
      plutil -replace "${key}" -"${type}" "${value}" ~/Library/Preferences/"${domain}".plist
  done
}

strapped_mac_utils_after () { 
  return   
}
