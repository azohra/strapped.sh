#!/bin/bash
strapped_baargav_tool_before () {
	if ! baargav_tool -V > /dev/null; then echo ":baargav_tool: baargav_tool is missing" && exit; fi
}

strapped_baargav_tool () {
	local repos_count
	local location
	local name
	local symlinks_count
	local dest
	local src
	
	repos_count=$(yq read "${1}" -j | jq -r ".baargav_tool.repos | length")
	symlinks_count=$(yq read "${1}" -j | jq -r ".baargav_tool.symlinks | length")
	
	for (( i=0; i < repos_count; i++ )); do
		location=$(yq read "${1}" -j | jq -r ".baargav_tool.repos[${i}].location")
		echo "#do shit with ${location}"
		name=$(yq read "${1}" -j | jq -r ".baargav_tool.repos[${i}].name")
		echo "#do shit with ${name}"
		apt-get install $name
	done
	
	for (( j=0; j < symlinks_count; j++ )); do
		dest=$(yq read "${1}" -j | jq -r ".baargav_tool.symlinks[${i}].dest")
		echo "#do shit with ${dest}"
		src=$(yq read "${1}" -j | jq -r ".baargav_tool.symlinks[${i}].src")
		echo "#do shit with ${src}"
	done
	
}

strapped_baargav_tool_after () {
	return
}
