#!/bin/bash 

function strapped_plutil() {
	# Variables to hold the deps and corresponding checks
	local __deps="plutil "
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

	local var_type
	local value
	local domain
	local key
	local i=0
	local input=${1}

	# performing functionality for plists
	for ((i=0; i<$( q_count "${input}" "plists"); i++)); do
		# Getting fields
		var_type=$(q "${input}" "plists.\\[${i}\\].var_type")
		value=$(q "${input}" "plists.\\[${i}\\].value")
		domain=$(q "${input}" "plists.\\[${i}\\].domain")
		key=$(q "${input}" "plists.\\[${i}\\].key")
		# Writing message
		pretty_print ":info:" "️🛠️ Updating ${domain} ${key} to ${value}"
		# Executing the command(s)
		run_command "plutil -replace ${key} -${var_type} ${value} ~/Library/Preferences/${domain}.plist"
	done
}
