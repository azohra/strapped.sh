#!/bin/bash
strapped_gagan_is_awesome_before () {
	if ! gagan_is_awesome -V > /dev/null; then echo ":gagan_is_awesome: gagan_is_awesome is missing" && exit; fi
}

strapped_gagan_is_awesome () {
	local apps_count
	local name
	local value
	local extensions_count
	local ext
	local state
	
	apps_count=$(yq read "${1}" -j | jq -r ".gagan_is_awesome.apps | length")
	extensions_count=$(yq read "${1}" -j | jq -r ".gagan_is_awesome.extensions | length")
	
	for (( i=0; i < apps_count; i++ )); do
		name=$(yq read "${1}" -j | jq -r ".gagan_is_awesome.apps[${i}].name")
		echo "#do shit with ${name}"
		value=$(yq read "${1}" -j | jq -r ".gagan_is_awesome.apps[${i}].value")
		echo "#do shit with ${value}"
	done
	
	for (( j=0; j < extensions_count; j++ )); do
		ext=$(yq read "${1}" -j | jq -r ".gagan_is_awesome.extensions[${i}].ext")
		echo "#do shit with ${ext}"
		state=$(yq read "${1}" -j | jq -r ".gagan_is_awesome.extensions[${i}].state")
		echo "#do shit with ${state}"
	done
	
}

strapped_gagan_is_awesome_after () {
	return
}
