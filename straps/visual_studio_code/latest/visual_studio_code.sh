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
		# Deciding if the dependancy has been satisfied
		if [[ ! "${__woo}" = "1" ]]; then echo "dependancy ${dep} not met" && exit 2; fi
	done

	# Declaring local variables for the 'extensions' routine
	local name
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'extensions'
	for ((i=0; i<$( ysh -T "${input}" -c extensions ); i++)); do

		# Getting fields for routine 'extensions'
		name=$( ysh -T "${input}" -l extensions -i ${i} -Q name )

		# Writing message for routine 'extensions'
		pretty_print ":info:" "💻 adding extension ${name}"

		# Executing the command(s) for routine 'extensions'
		run_command "code --install-extension ${name}"
	done
}
