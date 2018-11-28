#!/bin/bash
strapped_mac_utils_before () { 
  return
}

strapped_mac_utils () {
  local m_u_count
  local user_config=$1
  local dom
  local key
  local typ
  local val

  m_u_count=$(q_count "$user_config" "plists")

  for (( i=0; i < m_u_count; i++ )); do
    dom=$(q "$user_config" "plists.\\[${i}\\].domain")
    key=$(q "$user_config" "plists.\\[${i}\\].key")
    typ=$(q "$user_config" "plists.\\[${i}\\].type")
    val=$(q "$user_config" "plists.\\[${i}\\].value")

    echo "🛠️  Updating ${dom} ${key} to ${val}"
    plutil -replace "${key}" -"${typ}" "${val}" ~/Library/Preferences/"${dom}".plist
  done
}

strapped_mac_utils_after () { 
  return   
}
