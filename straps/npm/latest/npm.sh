#!/bin/bash 

function strapped_npm() {
	# Variables to hold the deps and corresponding checks
	local __deps="npm "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"npm")
				echo -e "
	Please ensure you have npm installed on your system 
	We reccomend using strapped to install npm 
	MacOS 
		 brew:  
			 packages:  
				 - { name: npm }  
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'packages' routine
	local name
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'packages'
	for ((i=0; i<$( ysh -T "${input}" -c packages ); i++)); do

		# Getting fields for routine 'packages'
		name=$( ysh -T "${input}" -l packages -i ${i} -Q name )

		# Writing message for routine 'packages'
		pretty_print ":info:" "☕ npm $(npm -v) installing ${name}"

		# Executing the command(s) for routine 'packages'
		run_command "npm install -g ${name}"
	done
}
