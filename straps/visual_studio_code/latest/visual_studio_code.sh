#!/bin/bash 

function strapped_visual_studio_code() {
	# Variables to hold the deps and corresponding checks
	local __deps="code "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"code")
				echo -e "
	Please ensure you have code (VScode) installed on your system 
	We reccomend using strapped to install VScode 
	MacOS 
		 brew:  
			 casks:  
				 - { name: visual-studio-code }  
"
			;;
			esac
			exit 1
		fi
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
