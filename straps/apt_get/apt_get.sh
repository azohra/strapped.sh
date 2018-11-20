#!/bin/bash
strapped_apt_get_before () {
	if ! apt_get -V > /dev/null; then echo ":apt_get: apt_get is missing" && exit; fi
}

strapped_apt_get () {
	local install_count
	local name
	
	install_count=$(yq read "${1}" -j | jq -r ".apt_get.install | length")
	
	for (( i=0; i < install_count; i++ )); do
		name=$(yq read "${1}" -j | jq -r ".apt_get.install[${i}].name")
		echo "#do shit with ${name}"
		apt-get install ${name}
	done
	
}

strapped_apt_get_after () {
	return
}
