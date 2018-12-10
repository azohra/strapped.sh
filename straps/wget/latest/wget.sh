#!/bin/bash 

function strapped_wget() {
	# Variables to hold the deps and corresponding checks
	local __deps="wget "
	local __checks="-v -V --version"
	local __woo=""

	# Performing each check for each dep
	for dep in ${__deps}; do
		for check in ${__checks}; do
			if "${dep}" "${check}" &> /dev/null; then __woo=1; fi
		done
	done

	# Deciding if the dependancy has been satisfied
	if [[ ! "${__woo}" = "1" ]]; then echo "deps not met" && exit 2; fi 

	local filename
	local url
	local folder
	local i=0
	local input=${1}

	# performing functionality for download
	for ((i=0; i<$( q_count "${input}" "download"); i++)); do
		# Getting fields
		filename=$(q "${input}" "download.\\[${i}\\].filename")
		url=$(q "${input}" "download.\\[${i}\\].url")
		folder=$(q "${input}" "download.\\[${i}\\].folder")
		# Writing message
		pretty_print ":info:" "💾 downloading ${url} into ${folder}/${filename}"
		# Executing the command(s)
		run_command "wget -P ${folder} -O {filename} ${url}"
	done
}
