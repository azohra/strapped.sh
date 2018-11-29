#!/bin/bash 

function strapped_mac_app_store() {
	# Variables to hold the deps and corresponding checks
	local __deps="mas "
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

	local name
	local id
	local i=0
	local input=${1}

	# performing functionality for apps
	for ((i=0; i<$( q_count "${input}" "apps"); i++)); do
		# Getting fields
		name=$(q "${input}" "apps.\\[${i}\\].name")
		id=$(q "${input}" "apps.\\[${i}\\].id")
		# Writing message
		echo -e "🍏 installing installing ${name}"
		# Executing the command(s)
		mas install "${id}"
	done
}
