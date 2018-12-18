#!/bin/bash 

function strapped_brew() {
	# Variables to hold the deps and corresponding checks
	local __deps="brew "
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

	# Declaring local variables for the 'taps' routine
	local name

	# Declaring local variables for the 'packages' routine
	local name

	# Declaring local variables for the 'casks' routine
	local name
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'taps'
	for ((i=0; i<$( ysh -T "${input}" -c taps ); i++)); do

		# Getting fields for routine 'taps'
		name=$( ysh -T "${input}" -l taps -i ${i} -Q name )

		# Writing message for routine 'taps'
		pretty_print ":info:" "🚰 tapping ${name}"

		# Executing the command(s) for routine 'taps'
		run_command "brew tap ${name}"
	done


	# performing functionality for routine 'packages'
	for ((i=0; i<$( ysh -T "${input}" -c packages ); i++)); do

		# Getting fields for routine 'packages'
		name=$( ysh -T "${input}" -l packages -i ${i} -Q name )

		# Writing message for routine 'packages'
		pretty_print ":info:" "🍺 installing ${name}"

		# Executing the command(s) for routine 'packages'
		run_command "brew list ${name} || brew install ${name}"
	done


	# performing functionality for routine 'casks'
	for ((i=0; i<$( ysh -T "${input}" -c casks ); i++)); do

		# Getting fields for routine 'casks'
		name=$( ysh -T "${input}" -l casks -i ${i} -Q name )

		# Writing message for routine 'casks'
		pretty_print ":info:" "🍻 installing ${name}"

		# Executing the command(s) for routine 'casks'
		run_command "brew cask list ${name} || brew cask install ${name}"
	done
}
