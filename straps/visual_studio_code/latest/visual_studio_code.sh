#!/bin/bash 

function strapped_visual_studio_code() {
	# Variables to hold the deps and corresponding checks
	local __deps="code "
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
	local i=0
	local input=${1}

	# performing functionality for extensions
	for ((i=0; i<$( q_count "${input}" "extensions"); i++)); do
		# Getting fields
		name=$(q "${input}" "extensions.\\[${i}\\].name")
		# Writing message
		pretty_print ":info:" "💻 adding extension ${name}"
		# Executing the command(s)
		run_command "code --install-extension ${name}"
	done
}
