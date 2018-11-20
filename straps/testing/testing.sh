#!/bin/bash
strapped_testing_before () {
	if ! testing -V > /dev/null; then echo ":testing: testing is missing" && exit; fi
}

strapped_testing () {
	local source_count
	local dir
	local mkdir_count
	local dir
	local ln_count
	local link
	local dir
	local echo_count
	local phrase
	
	source_count=$(yq read ${1} -j | jq -r ".testing.source | length")
	mkdir_count=$(yq read ${1} -j | jq -r ".testing.mkdir | length")
	ln_count=$(yq read ${1} -j | jq -r ".testing.ln | length")
	echo_count=$(yq read ${1} -j | jq -r ".testing.echo | length")
	
	for (( l=source_count; l>0; l-- )); do
		dir=$(yq read "${1}" -j | jq -r ".testing.source[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( k=mkdir_count; k>0; k-- )); do
		dir=$(yq read "${1}" -j | jq -r ".testing.mkdir[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( j=ln_count; j>0; j-- )); do
		link=$(yq read "${1}" -j | jq -r ".testing.ln[${i}-1].link")
		echo "#do shit with ${link}"
		dir=$(yq read "${1}" -j | jq -r ".testing.ln[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( i=echo_count; i>0; i-- )); do
		phrase=$(yq read "${1}" -j | jq -r ".testing.echo[${i}-1].phrase")
		echo "#do shit with ${phrase}"
	done
	
}

strapped_testing_after () {
	return
}
