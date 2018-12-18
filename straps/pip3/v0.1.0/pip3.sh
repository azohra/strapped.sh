#!/bin/bash 

function strapped_pip3() {
	# Variables to hold the deps and corresponding checks
	local __deps="pip3 "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"pip3")
				echo -e "
	Please ensure you have pip3 installed on your system 
	We reccomend using strapped to install pip3 
	MacOS 
		 brew:  
			 packages:  
				 - { name: pip3 }  
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
		pretty_print ":info:" "🐍 $(python3 --version) installing ${name}"

		# Executing the command(s) for routine 'packages'
		run_command "pip3 install ${name}"
	done
}
