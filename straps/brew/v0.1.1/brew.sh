#!/bin/bash 

function strapped_brew() {
	# Variables to hold the deps and corresponding checks
	local __deps="brew "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"brew")
				echo -e "
	Please ensure you have brew installed on your system 
	To install brew, follow the instructions at https://brew.sh/ 
"
			;;
			esac
			exit 1
		fi
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
		run_command "brew list ${name} &> /dev/null && echo ${name} is already installed. 1>&2 || (brew install ${name} && echo ${name} successfully installed. 1>&2 || ${name} failed to install. 1>&2 )"
	done


	# performing functionality for routine 'casks'
	for ((i=0; i<$( ysh -T "${input}" -c casks ); i++)); do

		# Getting fields for routine 'casks'
		name=$( ysh -T "${input}" -l casks -i ${i} -Q name )

		# Writing message for routine 'casks'
		pretty_print ":info:" "🍻 installing ${name}"

		# Executing the command(s) for routine 'casks'
		run_command "brew cask list ${name} &> /dev/null && echo ${name} is already installed. 1>&2 || (brew cask install ${name} && echo ${name} successfully installed. 1>&2 || ${name} failed to install. 1>&2 )"
	done
}
