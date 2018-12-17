#!/bin/bash 

function strapped_git() {
	# Variables to hold the deps and corresponding checks
	local __deps="git "
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

	# Declaring local variables for the 'clone' routine
	local repo
	local folder
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'clone'
	for ((i=0; i<$( ysh -T "${input}" -c clone ); i++)); do

		# Getting fields for routine 'clone'
		repo=$( ysh -T "${input}" -l clone -i ${i} -Q repo )
		folder=$( ysh -T "${input}" -l clone -i ${i} -Q folder )

		# Writing message for routine 'clone'
		pretty_print ":info:" "💾 cloning ${repo} into ${folder}"

		# Executing the command(s) for routine 'clone'
		run_command "if [ ! -d ${folder} ] ; then git clone ${repo} ${folder}; fi"
	done
}
