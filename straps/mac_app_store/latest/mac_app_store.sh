#!/bin/bash 

function strapped_mac_app_store() {
	# Variables to hold the deps and corresponding checks
	local __deps="mas "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "dep ${dep} not found:"
			case "${dep}" in
			"mas")
				echo -e "	Please ensure you have mas (mac app store) installed on your system 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'apps' routine
	local name
	local id
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'apps'
	for ((i=0; i<$( ysh -T "${input}" -c apps ); i++)); do

		# Getting fields for routine 'apps'
		name=$( ysh -T "${input}" -l apps -i ${i} -Q name )
		id=$( ysh -T "${input}" -l apps -i ${i} -Q id )

		# Writing message for routine 'apps'
		pretty_print ":info:" "🍏 installing installing ${name}"

		# Executing the command(s) for routine 'apps'
		run_command "mas install ${id}"
	done
}
