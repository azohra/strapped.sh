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
		# Deciding if the dependancy has been satisfied
		if [[ ! "${__woo}" = "1" ]]; then echo "dependancy ${dep} not met" && exit 2; fi
	done

	# Declaring local variables for the 'apps' routine
	local name
	local id
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'apps'
	for ((i=0; i<$( ysh -T "${input}" -c apps ); i++)); do

		# Getting fields for routine 'apps'
		name=$( ysh -T "${input}" -l apps -i ${i} -Q name )
		id=$( ysh -T "${input}" -l apps -i ${i} -Q id )

		# Writing message for routine 'apps'
		pretty_print ":info:" "🍏 installing installing ${name}"

		# Executing the command(s) for routine 'apps'
		run_command "mas install ${id}"
	done
}
