#!/bin/bash 

function strapped_hyper() {
	# Variables to hold the deps and corresponding checks
	local __deps="hyper "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"hyper")
				echo -e "	please install hyper 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'plugins' routine
	local name
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'plugins'
	for ((i=0; i<$( ysh -T "${input}" -c plugins ); i++)); do

		# Getting fields for routine 'plugins'
		name=$( ysh -T "${input}" -l plugins -i ${i} -Q name )

		# Writing message for routine 'plugins'
		pretty_print ":info:" "⚡ installing ${name}"

		# Executing the command(s) for routine 'plugins'
		run_command "hyper install ${name}"
	done
}
