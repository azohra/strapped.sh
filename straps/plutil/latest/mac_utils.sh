#!/bin/bash 

function strapped_mac_utils() {
	# Variables to hold the deps and corresponding checks
	local __deps="plutil say "
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
	local message
	local i=0
	local input=${1}

	# performing functionality for plutil
	for ((i=0; i<$( q_count "${input}" "plutil"); i++)); do
		# Getting fields
		var_type=$(q "${input}" "plutil.\\[${i}\\].var_type")
		value=$(q "${input}" "plutil.\\[${i}\\].value")
		domain=$(q "${input}" "plutil.\\[${i}\\].domain")
		key=$(q "${input}" "plutil.\\[${i}\\].key")
		# Writing message
		pretty_print ":info:" "️🛠️ Updating ${domain} ${key} to ${value}"
		# Executing the command(s)
		run_command "plutil -replace ${key} -${var_type} ${value} ~/Library/Preferences/${domain}.plist"
	done

	# performing functionality for say
	for ((i=0; i<$( q_count "${input}" "say"); i++)); do
		# Getting fields
		message=$(q "${input}" "say.\\[${i}\\].message")
		# Writing message
		pretty_print ":info:" "️🗣 Saying ${message}"
		# Executing the command(s)
		run_command "say ${message}"
	done
}
