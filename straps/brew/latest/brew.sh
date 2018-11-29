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
	done

	# Deciding if the dependancy has been satisfied
	if [[ ! "${__woo}" = "1" ]]; then echo "deps not met" && exit 2; fi 

	local name
	local name
	local name
	local i=0
	local input=${1}

	# performing functionality for packages
	for ((i=0; i<$( q_count "${input}" "packages"); i++)); do
		# Getting fields
		name=$(q "${input}" "packages.\\[${i}\\].name")
		# Writing message
		pretty_print ":info:" "🍺 installing ${name}"
		# Executing the command(s)
		run_command "brew list ${name} || brew install ${name}"
	done

	# performing functionality for taps
	for ((i=0; i<$( q_count "${input}" "taps"); i++)); do
		# Getting fields
		name=$(q "${input}" "taps.\\[${i}\\].name")
		# Writing message
		pretty_print ":info:" "🚰 tapping ${name}"
		# Executing the command(s)
		run_command "brew tap ${name}"
	done

	# performing functionality for casks
	for ((i=0; i<$( q_count "${input}" "casks"); i++)); do
		# Getting fields
		name=$(q "${input}" "casks.\\[${i}\\].name")
		# Writing message
		pretty_print ":info:" "🍻 installing ${name}"
		# Executing the command(s)
		run_command "brew cask list ${name} || brew cask install ${name}"
	done
}
