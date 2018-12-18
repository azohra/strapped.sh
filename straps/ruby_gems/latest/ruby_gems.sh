#!/bin/bash 

function strapped_ruby_gems() {
	# Variables to hold the deps and corresponding checks
	local __deps="gem "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "dep ${dep} not found:"
			case "${dep}" in
			"gem")
				echo -e "	Please ensure you have gem installed on your system 
	We reccomend using strapped to install ruby which contains gem 
	MacOS 
		 brew:  
			 packages:  
				 - { name: ruby }  
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
		pretty_print ":info:" "💎 installing ${name}"

		# Executing the command(s) for routine 'packages'
		run_command "gem install ${name}"
	done
}
